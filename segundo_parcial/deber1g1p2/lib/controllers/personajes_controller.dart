import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/personajes_model.dart';

class PersonajesController {
  final String baseUrl = "https://gateway.marvel.com/v1/public/characters";
  final String publicKey = "2b88013ee5cb3dd4e26977b9b08fc962";

  // Fetch personajes con paginación (limit y offset)
  Future<List<Personaje>> fetchPersonajes({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse(
      "$baseUrl?apikey=$publicKey&limit=$limit&offset=$offset",
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;

        // Convierte los resultados a una lista de objetos Personaje
        return results.map((json) => Personaje.fromJson(json)).toList();
      } else {
        throw Exception(
            "Error al obtener los personajes: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al conectar con la API de Marvel: $e");
    }
  }
}
