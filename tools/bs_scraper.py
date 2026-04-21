# main_scraper.py
import requests
import re
import json
import os
import time
from tqdm import tqdm
from urllib.parse import urlparse, unquote

import normalize_rarity as rn  # modulo separato che contiene normalize_item / normalize_list

API_BASE = "https://battle-spirits.fandom.com/api.php"

# Sessione persistente (MASSIVE SPEEDUP)
session = requests.Session()

# Cache immagini
image_cache = {}


# ---------------------------
# Utility: estrai blocco template gestendo parentesi annidate
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
# Utility: estrai il filename (con estensione se presente) dal campo image
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
# Utility: normalizza card_id rimuovendo estensione comune
# ---------------------------
def normalize_card_id_from_filename(filename):
    if not filename:
        return None
    no_ext = re.sub(r'\.(jpe?g|png|gif|svg|webp|bmp|tiff)$', '', filename, flags=re.IGNORECASE)
    return no_ext if no_ext else None


# ---------------------------
# 1) Ottieni lista di tutti i set (categorie)
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

        resp = session.get(API_BASE, params=params).json()

        for cat in resp["query"]["allcategories"]:
            name = cat["*"]
            if (
                name.startswith("BS") or
                name.startswith("BSC") or
                name.startswith("SD") or
                name.startswith("PB") or
                name.startswith("CP")
            ):
                sets.append(name)

        if "continue" in resp:
            accontinue = resp["continue"]["accontinue"]
        else:
            break

    os.makedirs("cards_public", exist_ok=True)
    with open("cards_public/sets.json", "w", encoding="utf-8") as f:
        json.dump(sorted(set(sets)), f, indent=2, ensure_ascii=False)

    print("✔ sets.json generato!")
    return sorted(set(sets))


# ---------------------------
# 2) Ottieni tutte le carte di un set
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

        resp = session.get(API_BASE, params=params).json()
        cards.extend(resp["query"]["categorymembers"])

        if "continue" in resp:
            cmcontinue = resp["continue"]["cmcontinue"]
        else:
            break

    return cards


# ---------------------------
# 3) Scarica wikitext della carta
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

    resp = session.get(API_BASE, params=params).json()
    pages = resp["query"]["pages"]
    pageid = next(iter(pages))
    return pages[pageid]["revisions"][0]["slots"]["main"]["*"]


# ---------------------------
# 4) Ottieni URL immagine (con cache)
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
    resp = session.get(API_BASE, params=params).json()
    pages = resp["query"]["pages"]
    pageid = next(iter(pages))
    page = pages[pageid]
    url = page["imageinfo"][0]["url"] if "imageinfo" in page else None
    image_cache[filename] = url
    return url


# ---------------------------
# Parsing template CardTable3 (versione robusta)
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


# ---------------------------
# MAIN: genera un file per ogni set (usa rarity_normalizer inline)
# ---------------------------
def main():
    os.makedirs("cards_public", exist_ok=True)

    sets = get_all_sets()

    for set_name in sets[:5]:  # per ora limitiamo a 5 set per test
        filename = f"cards_public/cards_public_{set_name}.json"
        cards = get_cards_in_set(set_name)
        total_cards = len(cards)

        if os.path.exists(filename):
            print(f"... Controllo esistenza: {filename} già presente")
            continue

        print(f"\n📦 Set: {set_name} — {total_cards} carte trovate")
        output = []

        for idx, card in enumerate(tqdm(cards, desc=f"Set {set_name}", unit="card"), start=1):
            title = card["title"]

            try:
                wikitext = get_wikitext(title)
            except Exception as e:
                print(f"Errore fetching wikitext per {title}: {e}")
                continue

            data = parse_cardtable3_basic(wikitext, title)

            if idx % 20 == 0:
                time.sleep(0.2)

            if data:
                # normalizza la rarity prima di aggiungere
                data, changed = rn.normalize_item(data, field="rarity")
                if changed:
                    print(f"[rarity normalized] {data.get('id')} -> {data.get('rarity')}")
                output.append(data)

        with open(filename, "w", encoding="utf-8") as f:
            json.dump(output, f, indent=2, ensure_ascii=False)

        # salva report per set
        normalized_output, report = rn.normalize_list(output, field="rarity")

        print(f"✔ {filename} generato con successo!")

if __name__ == "__main__":
    main()
