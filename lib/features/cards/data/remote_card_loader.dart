import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteCardsLoader {
  final String url;

  RemoteCardsLoader(this.url);

  Future<List<dynamic>> load() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Errore nel download del cards.json");
    }

    return jsonDecode(response.body);
  }
}
