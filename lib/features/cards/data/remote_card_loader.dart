import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteCardsLoader {
  final String url;

  RemoteCardsLoader(this.url);

  Future<List<dynamic>> load() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        print("⚠️  URL non raggiungibile: $url");
        return [];
      }

      final body = response.body.trim();

      // 🔍 Se è HTML → NON è JSON → ignora
      if (body.startsWith("<!DOCTYPE") ||
          body.startsWith("<html") ||
          body.contains("<title>")) {
        print("⚠️  Ignoro URL perché non contiene JSON valido: $url");
        return [];
      }

      // 🔍 Provo a decodificare il JSON
      final decoded = jsonDecode(body);

      if (decoded is List) {
        return decoded;
      } else {
        print("⚠️  JSON non è una lista: $url");
        return [];
      }
    } catch (e) {
      print("⚠️  Errore nel parsing JSON da $url → $e");
      return [];
    }
  }
}
