import 'package:battle_spirits_online/features/cards/data/local/cards_dao.dart';
import 'package:battle_spirits_online/features/cards/domain/card_model.dart';
import 'package:battle_spirits_online/features/cards/domain/card_level.dart';
import 'package:battle_spirits_online/features/cards/data/image_downloader_service.dart';

class CardsImporter {
  final CardsDao dao;
  final ImageDownloaderService imageDownloader = ImageDownloaderService();

  CardsImporter(this.dao);

  Future<void> importFromJsonData(List<dynamic> jsonData) async {
    for (final item in jsonData) {
      final card = _mapJsonToCardModel(item);

      // Scarica immagine
      final localPath = await imageDownloader.downloadImage(
        card.imageUrl,
        card.id,
      );

      // Aggiorna il modello con il path locale
      final updatedCard = card.copyWith(imageUrl: localPath);

      // Salva nel DB
      await dao.insertOrUpdate(updatedCard);
    }
  }

  CardModel _mapJsonToCardModel(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      cardNumber: json['cardNumber'],
      nameEn: json['nameEn'],
      type: json['type'],
      color: json['color'],
      cost: json['cost'],
      levels: (json['levels'] as List)
          .map((e) => CardLevel.fromJson(e))
          .toList(),
      rarity: json['rarity'],
      set: json['set'],
      imageUrl: json['imageUrl'],
      effectTextRewrite: json['effectTextRewrite'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      parallelVariants: List<String>.from(json['parallelVariants'] ?? []),
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
    );
  }
}
