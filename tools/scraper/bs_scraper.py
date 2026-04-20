import requests
import re
import json
import os

API_BASE = "https://battle-spirits.fandom.com/api.php"


# ============================================================
# 1) Ottieni lista di tutti i set (categorie)
# ============================================================
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

        resp = requests.get(API_BASE, params=params).json()

        for cat in resp["query"]["allcategories"]:
            name = cat["*"]

            # Filtra solo categorie che rappresentano set reali
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
    with open("cards_public/sets.json", "w", encoding="utf-8") as f:
        json.dump(sets, f, indent=2, ensure_ascii=False)

    print("✔ sets.json generato!")
    return sorted(set(sets))


# ============================================================
# 2) Ottieni tutte le carte di un set
# ============================================================
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

        resp = requests.get(API_BASE, params=params).json()
        cards.extend(resp["query"]["categorymembers"])

        if "continue" in resp:
            cmcontinue = resp["continue"]["cmcontinue"]
        else:
            break

    return cards


# ============================================================
# 3) Scarica wikitext della carta
# ============================================================
def get_wikitext(title):
    params = {
        "action": "query",
        "titles": title,
        "prop": "revisions",
        "rvslots": "main",
        "rvprop": "content",
        "format": "json"
    }

    resp = requests.get(API_BASE, params=params).json()
    pages = resp["query"]["pages"]
    pageid = next(iter(pages))
    return pages[pageid]["revisions"][0]["slots"]["main"]["*"]


# ============================================================
# 4) Ottieni URL immagine
# ============================================================
def get_image_url(filename):
    params = {
        "action": "query",
        "titles": f"File:{filename}",
        "prop": "imageinfo",
        "iiprop": "url",
        "format": "json"
    }

    resp = requests.get(API_BASE, params=params).json()
    pages = resp["query"]["pages"]
    pageid = next(iter(pages))
    page = pages[pageid]

    if "imageinfo" in page:
        return page["imageinfo"][0]["url"]

    return None


# ============================================================
# 5) Parser semplice del template {{CardTable3}}
# ============================================================
def parse_cardtable3_basic(wikitext, page_title):
    match = re.search(r"\{\{CardTable3(.*?)\}\}", wikitext, re.DOTALL)
    if not match:
        return None

    block = match.group(1)

    def get_field(name):
        pattern = rf"\|\s*{name}\s*=\s*(.*)"
        m = re.search(pattern, block)
        return m.group(1).strip() if m else None

    image = get_field("image")
    type_ = get_field("type")
    color = get_field("color")
    cost = get_field("cost")
    family = get_field("family")
    rarity = get_field("rarity1")
    set_ = get_field("set1")

    card_id = image.replace(".jpg", "").replace(".png", "") if image else None
    image_url = get_image_url(image) if image else None

    return {
        "id": card_id,
        "nameEn": page_title,
        "type": type_,
        "color": color,
        "cost": int(cost) if cost and cost.isdigit() else cost,
        "family": family,
        "rarity": rarity,
        "set": set_,
        "imageUrl": image_url,
        "effectRaw": None  # LEGAL & PUBLIC SAFE
    }


# ============================================================
# 6) MAIN: genera un file per ogni set
# ============================================================
def main():
    os.makedirs("cards_public", exist_ok=True)

    sets = get_all_sets()
    
    for set_name in sets[:3]:
        filename = f"cards_public/cards_public_{set_name}.json"

        # Skip if file already exists
        if os.path.exists(filename):
            print(f"⏩ {filename} already exists, skip.")
            continue

        cards = get_cards_in_set(set_name)
        output = []

        for card in cards:
            title = card["title"]
            print(f"Parsing {title}...")

            wikitext = get_wikitext(title)
            data = parse_cardtable3_basic(wikitext, title)

            if data:
                output.append(data)

        with open(filename, "w", encoding="utf-8") as f:
            json.dump(output, f, indent=2, ensure_ascii=False)

        print(f"✔ {filename} generato con successo!")


if __name__ == "__main__":
    main()
