import 'dart:convert';
import 'package:http/http.dart' as http;
import '/../models/comics_model.dart';

class ComicController {
  final String baseUrl = "https://gateway.marvel.com/v1/public/comics";
  final String publicKey = "2b88013ee5cb3dd4e26977b9b08fc962";

  Future<List<Comic>> fetchComics({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse(
      "$baseUrl?apikey=$publicKey&limit=$limit&offset=$offset",
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;
        return results.map((json) => Comic.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los cómics: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al conectar con la API de Marvel: $e");
    }
  }
}
