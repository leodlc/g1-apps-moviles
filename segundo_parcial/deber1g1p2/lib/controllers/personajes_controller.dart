import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personajes_model.dart';

class PersonajesController {
  final String baseUrl = "https://gateway.marvel.com:443/v1/public/characters";
  final String apiKey = "TU_API_KEY"; // Reemplaza con tu API Key de Marvel
  final String hash = "TU_HASH"; // Hash generado para la autenticación
  final String ts = "1"; // Timestamp usado para el hash

  Future<List<Personaje>> fetchPersonajes() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl?ts=$ts&apikey=$apiKey&hash=$hash&limit=20'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;
        return results.map((json) => Personaje.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los personajes');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
