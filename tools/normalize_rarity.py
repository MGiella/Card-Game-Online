import re
from collections import Counter
import json

# Mappa base per normalizzare valori comuni
_NORMALIZATION_MAP = {
    "common": "Common",
    "uncommon": "Uncommon",
    "rare": "Rare",
    "x-rare": "X-Rare",
    "x rare": "X-Rare",
    "xrare": "X-Rare",
    "x-rare": "X-Rare",
    "master rare": "Master Rare",
    "masterrare": "Master Rare",
    "promo": "Promo",
    "promotional": "Promo",
    "": "Unknown",
    None: "Unknown"
}

def normalize_rarity(raw):
    """
    Normalizza una singola stringa raw di rarity in un valore coerente.
    Restituisce sempre una stringa (es. "Common", "X-Rare", "Unknown").
    """
    if raw is None:
        return "Unknown"
    s = str(raw).strip()
    key = s.lower()

    # mappa diretta
    if key in _NORMALIZATION_MAP:
        return _NORMALIZATION_MAP[key]

    # heuristics
    if "common" in key:
        return "Common"
    if "uncommon" in key:
        return "Uncommon"
    # 'master' + 'rare'
    if "master" in key and "rare" in key:
        return "Master Rare"
    # x-rare variants
    if key.startswith("x") and "rare" in key:
        return "X-Rare"
    # generic rare (but not master/x)
    if "rare" in key and "master" not in key and "x" not in key:
        return "Rare"
    if "promo" in key:
        return "Promo"

    # fallback: Title Case the token
    return s.title()

def normalize_item(item, field="rarity"):
    """
    Normalizza il campo `field` di un singolo item (dizionario).
    Restituisce una tupla (normalized_item, changed) dove changed è True se il valore è stato modificato.
    """
    raw = item.get(field)
    normalized = normalize_rarity(raw)
    changed = (raw != normalized)
    item[field] = normalized
    return item, changed

def normalize_list(items, field="rarity"):
    """
    Normalizza una lista di item (lista di dict). Restituisce:
      - normalized_items (la stessa lista modificata)
      - report dict con conteggi e anomalie
    """
    seen = Counter()
    anomalies = []

    for item in items:
        raw = item.get(field)
        normalized = normalize_rarity(raw)
        seen[raw] += 1
        if normalized != raw:
            anomalies.append({
                "id": item.get("id"),
                "nameEn": item.get("nameEn"),
                "rarity_raw": raw,
                "rarity_normalized": normalized
            })
        item[field] = normalized

    report = {
        "total": len(items),
        "distinct_raw_rarities": len(seen),
        "raw_counts": dict(seen),
        "anomalies_count": len(anomalies),
        "anomalies_sample": anomalies[:200]
    }
    return items, report

def write_report(report, path):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
