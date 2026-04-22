# main_scraper.py
import re
import json
import os
import string
import time
import random
from tqdm import tqdm
from urllib.parse import urlparse, unquote

import normalize_rarity as rn  # modulo separato che contiene normalize_item / normalize_list

API_BASE = "https://battle-spirits.fandom.com/api.php"

# Try to use cloudscraper to handle Cloudflare challenges
try:
    import cloudscraper
    SCRAPER = cloudscraper.create_scraper(
        browser={
            "browser": "chrome",
            "platform": "windows",
            "mobile": False
        }
    )
    # set browser-like headers on the scraper
    SCRAPER.headers.update({
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0 Safari/537.36",
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Language": "en-US,en;q=0.9",
        "Referer": "https://battle-spirits.fandom.com/",
        "Connection": "keep-alive",
    })
except Exception:
    # fallback to requests if cloudscraper is not available
    import requests
    SCRAPER = requests.Session()
    SCRAPER.headers.update({
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0 Safari/537.36",
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Language": "en-US,en;q=0.9",
        "Referer": "https://battle-spirits.fandom.com/",
        "Connection": "keep-alive",
    })

# Cache immagini
image_cache = {}

# =========================
# Config API helper
# =========================
MAX_RETRIES = 6
BACKOFF_BASE = 1.0
DEFAULT_TIMEOUT = 15  # seconds

# Debug file for Cloudflare challenge
CF_DEBUG_FILE = "cf_challenge_snippet.html"


def backoff_sleep(attempt):
    """Exponential backoff with jitter."""
    wait = BACKOFF_BASE * (2 ** attempt) + random.uniform(0, 1)
    time.sleep(wait)


def api_get(params, timeout=DEFAULT_TIMEOUT):
    """
    GET to API_BASE using SCRAPER (cloudscraper or requests.Session) with retries,
    Cloudflare challenge handling and diagnostics.
    Returns parsed JSON dict on success, otherwise raises RuntimeError.
    """
    for attempt in range(MAX_RETRIES):
        try:
            resp = SCRAPER.get(API_BASE, params=params, timeout=timeout)
        except Exception as e:
            # network/connection error: retry with backoff
            print(f"[api_get] Request exception attempt {attempt+1}/{MAX_RETRIES}: {e}. Retrying...")
            backoff_sleep(attempt)
            continue

        status = getattr(resp, "status_code", None)
        text = getattr(resp, "text", "")

        # 200: try to parse JSON
        if status == 200:
            try:
                return resp.json()
            except Exception:
                # body not JSON: save for debug and raise
                snippet = text[:20000]
                try:
                    with open("api_nonjson_debug.html", "w", encoding="utf-8") as f:
                        f.write(snippet)
                except Exception:
                    pass
                raise RuntimeError("[api_get] HTTP 200 but body not JSON. Saved api_nonjson_debug.html")

        # Cloudflare challenge / rate limit
        if status == 429 or (hasattr(resp, "headers") and resp.headers.get("cf-mitigated")) or "Just a moment" in text:
            # save snippet for debug
            try:
                with open(CF_DEBUG_FILE, "w", encoding="utf-8") as f:
                    f.write(text)
            except Exception:
                pass
            # use Retry-After if present
            ra = getattr(resp, "headers", {}).get("Retry-After") if hasattr(resp, "headers") else None
            if ra and str(ra).isdigit():
                wait = int(ra)
            else:
                # longer wait for Cloudflare challenge
                wait = 30 * (2 ** attempt)
            print(f"[api_get] Cloudflare challenge / 429 detected (status {status}). Waiting {wait}s (attempt {attempt+1}/{MAX_RETRIES}).")
            time.sleep(wait)
            continue

        # server temporary errors: retry
        if status in (500, 502, 503, 504):
            print(f"[api_get] Server error {status}. Retrying (attempt {attempt+1}/{MAX_RETRIES})...")
            backoff_sleep(attempt)
            continue

        # non-retryable error: raise with snippet
        snippet = text[:2000].replace("\n", " ")
        raise RuntimeError(f"[api_get] HTTP {status}. Body snippet: {snippet}")

    raise RuntimeError(f"[api_get] Max retries exceeded ({MAX_RETRIES}) for params: {params}")


# ---------------------------
# Utility: extract template block handling nested braces
# ---------------------------
def extract_template_block(wikitext, template_name):
    start_token = "{{" + template_name
    start = wikitext.find(start_token)
    if start == -1:
        return None
    i = start
    depth = 0
    length = len(wikitext)
    while i < length - 1:
        if wikitext[i:i+2] == "{{":
            depth += 1
            i += 2
            continue
        if wikitext[i:i+2] == "}}":
            depth -= 1
            i += 2
            if depth == 0:
                # return inner content (without outer braces)
                return wikitext[start + len(start_token): i - 2]
            continue
        i += 1
    return None


# ---------------------------
# Utility: extract filename (with extension if present) from image field
# ---------------------------
def extract_filename_from_image_field(image_value):
    if not image_value:
        return None
    img = image_value.strip()
    img = img.split("|", 1)[0].strip()
    if img.lower().startswith("http://") or img.lower().startswith("https://"):
        parsed = urlparse(img)
        path = unquote(parsed.path)
        basename = path.rstrip("/").split("/")[-1]
    else:
        basename = re.sub(r'^(File:|file:)', '', img, flags=re.IGNORECASE)
        basename = basename.split("/")[-1].strip()
    if not basename:
        return None
    basename = basename.split("?", 1)[0]
    return basename if basename else None


# ---------------------------
# Utility: normalize card id removing common extensions
# ---------------------------
def normalize_card_id_from_filename(filename):
    if not filename:
        return None
    no_ext = re.sub(r'\.(jpe?g|png|gif|svg|webp|bmp|tiff)$', '', filename, flags=re.IGNORECASE)
    return no_ext if no_ext else None


# ---------------------------
# 1) Get all sets (categories)
# ---------------------------
def get_all_sets():
    sets = []
    accontinue = None

    while True:
        params = {
            "action": "query",
            "list": "allcategories",
            "aclimit": "500",
            "format": "json"
        }

        if accontinue:
            params["accontinue"] = accontinue

        try:
            resp = api_get(params)
        except Exception as e:
            print(f"[get_all_sets] API error: {e}")
            break

        if "query" not in resp or "allcategories" not in resp["query"]:
            print(f"[get_all_sets] Unexpected response keys: {list(resp.keys())}")
            break

        for cat in resp["query"]["allcategories"]:
            name = cat.get("*")
            if not name:
                continue
            if (
                name.startswith("BS") or
                name.startswith("BSC") or
                name.startswith("SD") or
                name.startswith("PB") or
                name.startswith("CP")
            ):
                sets.append(name)

        if "continue" in resp:
            accontinue = resp["continue"].get("accontinue")
            if not accontinue:
                break
        else:
            break

    os.makedirs("cards_public", exist_ok=True)
    with open("cards_public/sets.json", "w", encoding="utf-8") as f:
        json.dump(sorted(set(sets)), f, indent=2, ensure_ascii=False)

    print("✔ sets.json generato!")
    return sorted(set(sets))


# ---------------------------
# 2) Get all cards in a set
# ---------------------------
def get_cards_in_set(set_name):
    cards = []
    cmcontinue = None

    while True:
        params = {
            "action": "query",
            "list": "categorymembers",
            "cmtitle": f"Category:{set_name}",
            "cmlimit": "500",
            "format": "json"
        }

        if cmcontinue:
            params["cmcontinue"] = cmcontinue

        try:
            resp = api_get(params)
        except Exception as e:
            print(f"[get_cards_in_set] API error for set {set_name}: {e}")
            break

        if "query" not in resp or "categorymembers" not in resp["query"]:
            print(f"[get_cards_in_set] Unexpected response for {set_name}: keys={list(resp.keys())}")
            break

        cards.extend(resp["query"]["categorymembers"])

        if "continue" in resp:
            cmcontinue = resp["continue"].get("cmcontinue")
            if not cmcontinue:
                break
        else:
            break

    return cards


# ---------------------------
# 3) Download wikitext for a page
# ---------------------------
def get_wikitext(title):
    params = {
        "action": "query",
        "titles": title,
        "prop": "revisions",
        "rvslots": "main",
        "rvprop": "content",
        "format": "json"
    }

    resp = api_get(params)
    pages = resp.get("query", {}).get("pages")
    if not pages:
        raise RuntimeError(f"[get_wikitext] No pages for title {title}. Resp keys: {list(resp.keys())}")
    pageid = next(iter(pages))
    page = pages[pageid]
    revs = page.get("revisions")
    if not revs:
        return None
    return revs[0]["slots"]["main"]["*"]


# ---------------------------
# 4) Get image URL (with cache)
# ---------------------------
def get_image_url(filename):
    if not filename:
        return None
    if filename in image_cache:
        return image_cache[filename]
    params = {
        "action": "query",
        "titles": f"File:{filename}",
        "prop": "imageinfo",
        "iiprop": "url",
        "format": "json"
    }
    try:
        resp = api_get(params)
    except Exception as e:
        print(f"[get_image_url] API error for file {filename}: {e}")
        image_cache[filename] = None
        return None

    pages = resp.get("query", {}).get("pages", {})
    if not pages:
        image_cache[filename] = None
        return None
    pageid = next(iter(pages))
    page = pages[pageid]
    url = page.get("imageinfo", [{}])[0].get("url") if "imageinfo" in page else None
    image_cache[filename] = url
    return url


# ---------------------------
# Parse CardTable3 template (robust)
# ---------------------------
def parse_cardtable3_basic(wikitext, page_title):
    block = extract_template_block(wikitext, "CardTable3")
    if not block:
        return None

    def get_field(name):
        name_escaped = re.escape(name)
        pattern = rf"^\|\s*{name_escaped}\s*\d*\s*=\s*(.*?)(?=\n\||\n$)"
        m = re.search(pattern, block, flags=re.MULTILINE | re.DOTALL)
        if not m:
            m = re.search(pattern, block, flags=re.MULTILINE | re.DOTALL | re.IGNORECASE)
        if not m:
            return None
        value = m.group(1).strip()
        value = re.sub(r"\s+$", "", value)
        return value

    image_field_raw = get_field("image")
    type_ = get_field("type")
    color = get_field("color")
    cost = get_field("cost")
    family = get_field("family")
    rarity = get_field("rarity1") or get_field("rarity")
    set_ = get_field("set1") or get_field("set")

    filename_with_ext = extract_filename_from_image_field(image_field_raw)
    card_id = normalize_card_id_from_filename(filename_with_ext) if filename_with_ext else None
    image_url = get_image_url(filename_with_ext) if filename_with_ext else None
    if image_url is None:
        image_url = "null"

    cost_val = None
    if cost:
        try:
            cost_val = int(cost.strip())
        except Exception:
            cost_val = cost.strip()

    return {
        "id": card_id,
        "nameEn": page_title,
        "type": type_.strip() if type_ else None,
        "color": color.strip() if color else None,
        "cost": cost_val,
        "family": family.strip() if family else None,
        "rarity": rarity.strip() if rarity else None,
        "set": set_.strip() if set_ else None,
        "imageUrl": image_url,
        "effectRaw": None
    }

def sanitize_filename(name, replace_char="_"):
    """
    Sostituisce caratteri non sicuri in `name` con replace_char.
    Mantiene lettere, numeri, spazi, trattini e underscore.
    """
    allowed = "-_.() %s%s" % (string.ascii_letters, string.digits)
    return "".join(c if c in allowed else replace_char for c in name).strip()

# ---------------------------
# MAIN: generate a file per set (normalize rarity inline)
# ---------------------------
def main():
    os.makedirs("cards_public", exist_ok=True)

    sets = get_all_sets()

    for set_name in sets:
        set_name = sanitize_filename(set_name, replace_char="_")
        filename = f"cards_public/cards_public_{set_name}.json"
        cards = get_cards_in_set(set_name)
        total_cards = len(cards)

        if os.path.exists(filename):
            print(f"... Controllo esistenza: {filename} già presente")
            continue

        print(f"\n📦 Set: {set_name} — {total_cards} carte trovate")
        output = []

        for idx, card in enumerate(tqdm(cards, desc=f"Set {set_name}", unit="card"), start=1):
            title = card.get("title")
            if not title:
                continue

            try:
                wikitext = get_wikitext(title)
            except Exception as e:
                print(f"Errore fetching wikitext per {title}: {e}")
                # if Cloudflare challenge was detected and saved, stop to avoid worsening mitigation
                if os.path.exists(CF_DEBUG_FILE):
                    print(f"Cloudflare challenge detected earlier. Stopping set {set_name} to avoid further throttling.")
                    break
                continue

            data = parse_cardtable3_basic(wikitext, title)

            if idx % 20 == 0:
                time.sleep(0.2)

            if data:
                # normalize rarity before appending
                data, changed = rn.normalize_item(data, field="rarity")
                if changed:
                    print(f"[rarity normalized] {data.get('id')} -> {data.get('rarity')}")
                output.append(data)

        # save set file
        with open(filename, "w", encoding="utf-8") as f:
            json.dump(output, f, indent=2, ensure_ascii=False)

    
        print(f"✔ {filename} generato con successo!")


if __name__ == "__main__":
    main()
