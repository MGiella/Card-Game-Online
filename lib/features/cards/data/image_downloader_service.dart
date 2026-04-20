import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageDownloaderService {
  Future<String> downloadImage(String url, String fileNameWithoutExt) async {
    // 🔍 Se è un URL remoto → scarica
    if (url.startsWith("http://") || url.startsWith("https://")) {

      // Ricavo estensione dall'URL
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();

      String extension = ".jpg"; // default
      if (path.endsWith(".png")) extension = ".png";
      if (path.endsWith(".jpg")) extension = ".jpg";
      if (path.endsWith(".jpeg")) extension = ".jpeg";
      if (path.endsWith(".webp")) extension = ".webp";

      // Nome file completo
      final fullName = "$fileNameWithoutExt$extension";

      final dir = await getApplicationSupportDirectory();
      final imagesDir = Directory("${dir.path}/images");

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final filePath = "${imagesDir.path}/$fullName";
      final file = File(filePath);

      // Se esiste già → non riscaricare
      if (await file.exists()) {
        return filePath;
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception("Errore nel download dell'immagine: ${response.statusCode}");
      }

      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    }

    // 🔍 Se è un percorso locale → restituiscilo
    return url;
  }
}
