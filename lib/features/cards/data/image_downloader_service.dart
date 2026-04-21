import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:battle_spirits_online/features/cards/data/local/cards_dao.dart';
import 'package:battle_spirits_online/features/cards/domain/card_model.dart';

class ImageDownloaderService {
  final CardsDao cardsDao;

  ImageDownloaderService({required this.cardsDao});

  Future<String?> downloadImageForCard(CardModel card) async {
    try {
      // Se già scaricata → restituisci path locale
      // Se il DB dice che è scaricata, controlla che il file esista davvero
    if (card.imageDownloaded && card.imageLocalPath != null) {
      final existingFile = File(card.imageLocalPath!);
      if (await existingFile.exists()) {
        return card.imageLocalPath;
      } 
}

      final url = card.imageUrl;
      if (url.isEmpty) return null;

      // Determina estensione
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();

      String extension = ".jpg";
      if (path.endsWith(".png")) extension = ".png";
      if (path.endsWith(".jpg")) extension = ".jpg";
      if (path.endsWith(".jpeg")) extension = ".jpeg";
      if (path.endsWith(".webp")) extension = ".webp";

      final dir = await getApplicationSupportDirectory();
      final imagesDir = Directory("${dir.path}/images");

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final filePath = "${imagesDir.path}/${card.id}$extension";
      final file = File(filePath);

      // Se esiste già → aggiorna DB e ritorna
      if (await file.exists()) {
        await cardsDao.updateImageInfo(
          card.id,
          localPath: filePath,
          downloaded: true,
        );
        return filePath;
      }

      // Scarica immagine
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      await file.writeAsBytes(response.bodyBytes);

      // 🔥 Aggiorna DB
      await cardsDao.updateImageInfo(
        card.id,
        localPath: filePath,
        downloaded: true,
      );

      return filePath;
    } catch (e) {
      print("❌ Errore download immagine per ${card.id}: $e");
      return null;
    }
  }
}
