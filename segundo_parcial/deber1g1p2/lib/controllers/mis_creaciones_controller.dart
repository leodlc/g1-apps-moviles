import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/datos_model.dart';

class MisCreacionesController {
  final String _baseUrl = 'http://localhost:3000/api/1.0';

  // Crear un dato (POST) dinámico
  Future<void> crearDato(String tipo, Datos dato) async {
    final String endpoint = _obtenerRutaCreacion(tipo);
    final url = Uri.parse('$_baseUrl/$tipo/$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dato.toJson(tipo)),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear el dato: ${response.body}");
    }
  }

  // Obtener películas creadas por el usuario (GET)
  Future<List<Datos>> obtenerMisPeliculas() async {
    final url = Uri.parse('$_baseUrl/peliculas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      final List<dynamic> dataList = decodedResponse['data'] ?? [];
      return dataList.map((json) => Datos.fromJson(json, 'peliculas')).toList();
    } else {
      throw Exception("Error al obtener las películas: ${response.body}");
    }
  }

  Future<List<Datos>> obtenerMisPersonajes() async {
    final url = Uri.parse('http://localhost:3000/api/1.0/personajes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      final List<dynamic> dataList = decodedResponse['data'] ?? [];
      return dataList
          .map((json) => Datos.fromJson(json, 'personajes'))
          .toList();
    } else {
      throw Exception("Error al obtener los personajes: ${response.body}");
    }
  }

  // Eliminar película (DELETE)
  Future<void> eliminarPelicula(String id) async {
    final url = Uri.parse('$_baseUrl/peliculas/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la película: ${response.body}');
    }
  }

  // Actualizar película (PATCH)
  Future<void> actualizarPelicula(String id, Datos dato) async {
    final url = Uri.parse('$_baseUrl/peliculas/$id');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dato.toJson('peliculas')),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la película: ${response.body}');
    }
  }

  Future<void> eliminarPersonaje(String id) async {
    final url = Uri.parse('http://localhost:3000/api/1.0/personajes/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el personaje: ${response.body}');
    }
  }

  // Obtener lista de cómics creados
  Future<List<Datos>> obtenerMisComics() async {
    final url = Uri.parse('$_baseUrl/comics');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      final List<dynamic> dataList = decodedResponse['data'] ?? [];

      return dataList.map((json) => Datos.fromJson(json, 'comics')).toList();
    } else {
      throw Exception("Error al obtener los cómics: ${response.body}");
    }
  }

  // Eliminar un cómic por ID
  Future<void> eliminarComic(String id) async {
    final url = Uri.parse('$_baseUrl/comics/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el cómic: ${response.body}');
    }
  }

  // Actualizar un cómic
  Future<void> actualizarComic(String id, Datos comic) async {
    final url = Uri.parse('$_baseUrl/comics/$id');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(comic.toJson('comics')),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el cómic: ${response.body}');
    }
  }

  // Método para obtener la ruta específica según el tipo
  String _obtenerRutaCreacion(String tipo) {
    switch (tipo) {
      case 'personajes':
        return 'createCharacter';
      case 'peliculas':
        return 'createMovie';
      case 'comics':
        return 'createComic';
      default:
        throw Exception("Tipo no válido: $tipo");
    }
  }
}
