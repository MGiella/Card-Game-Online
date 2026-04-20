import 'package:battle_spirits_online/features/cards/data/local/cards_dao.dart';
import 'package:battle_spirits_online/features/cards/domain/card_model.dart';
import 'package:battle_spirits_online/features/cards/domain/card_level.dart';

class CardsImporter {
  final CardsDao dao;

  CardsImporter(this.dao);

  Future<void> importFromJsonData(List<dynamic> jsonData) async {
  int count = 0;

  for (final item in jsonData) {
    final card = _mapJsonToCardModel(item);

    await dao.insertOrUpdate(card);

    count++;

    // 🔥 Micro‑pausa ogni 20 carte per non bloccare il main thread
    if (count % 20 == 0) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}

  CardModel _mapJsonToCardModel(Map<String, dynamic> json) {
  return CardModel(
    id: json['id'] ?? '',
    cardNumber: json['cardNumber'] ?? '',
    nameEn: json['nameEn'] ?? '',
    type: json['type'] ?? '',
    color: json['color'] ?? '',
    cost: json['cost'] ?? 0,
    family: json['family'] ?? '',
    levels: (json['levels'] as List? ?? [])
        .map((e) => CardLevel.fromJson(e))
        .toList(),

    rarity: json['rarity'] ?? '',
    set: json['set'] ?? '',

    imageUrl: json['imageUrl'] ?? '',

    effectTextRewrite: json['effectTextRewrite'] ?? '',

    keywords: List<String>.from(json['keywords'] ?? []),
    parallelVariants: List<String>.from(json['parallelVariants'] ?? []),

    releaseDate: json['releaseDate'] != null
        ? DateTime.tryParse(json['releaseDate'])
        : null,

    // campi locali
    imageLocalPath: null,
    imageDownloaded: false,
    effectRaw: null,
    effectScrapedAt: null,
  );
}

}
