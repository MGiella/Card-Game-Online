import 'package:battle_spirits_online/features/cards/data/local/cards_dao.dart';
import 'package:battle_spirits_online/features/cards/domain/card_model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart';


class EffectScraperService {
  final CardsDao cardsDao;

  EffectScraperService({required this.cardsDao});

  Future<void> scrapeEffectForCard(CardModel card) async {
    try {
      // Se già presente → non riscrapare
      if (card.effectRaw != null && card.effectRaw!.isNotEmpty) {
        return;
      }

      // URL della pagina Fandom
      final url = "https://battle-spirits.fandom.com/wiki/${card.nameEn.replaceAll(' ', '_')}";
      final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.9",
        "Referer": "https://google.com",
        "DNT": "1",
        "Upgrade-Insecure-Requests": "1",
      },
    );

      if (response.statusCode != 200) {
        print(url);
        print("❌ Errore scraping effetto per ${card.id}: HTTP ${response.statusCode}");
        return;
      }

      final html = response.body;



      var effect = _extractEffect(html);

      if (effect == null || effect.isEmpty) {
        print("⚠️ Effetto non trovato per ${card.id} (${card.nameEn})");
        effect = "";
      }

      // 🔥 Aggiorna DB
      await cardsDao.updateEffect(
        card.id,
        effectRaw: effect,
        scrapedAt: DateTime.now(),
      );

    } catch (e) {
      print("❌ Errore scraping effetto per ${card.id}: $e");
    }
  }

  // ---------------------------------------------------------
  // Estrazione placeholder (da migliorare)
  // ---------------------------------------------------------
  String? _extractEffect(String htmlSource) {
    final document = html.parse(htmlSource);

    // 1) Trova tutti i <th>
    final ths = document.querySelectorAll('th');

    for (final th in ths) {
      final label = th.text.trim().toLowerCase();

      // 2) Cerca "card effects" o "effect"
      if (label == 'card effects' || label == 'effect') {
        final tr = th.parent; // <tr> che contiene il th
        if (tr == null) continue;

        // 3) Il prossimo <tr> contiene il <td> con l'effetto
        final nextTr = tr.nextElementSibling;
        if (nextTr == null) continue;

        final td = nextTr.querySelector('td');
        if (td == null) continue;

        // 4) Pulisci il testo
        final raw = td.text.trim();
        final cleaned = _cleanEffectText(raw);

        return cleaned.isEmpty ? null : cleaned;
      }
    }

    return null;
  } 

  String _cleanEffectText(String raw) {
    return raw
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
