import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/datos_model.dart';

class MisCreacionesController {
  final String _baseUrl = 'http://localhost:3000/api/1.0';

  // Crear un dato (POST) dinámico
  Future<void> crearDato(String tipo, Datos dato) async {
    final String endpoint =
        _obtenerRutaCreacion(tipo); // Obtener ruta específica
    final url = Uri.parse('$_baseUrl/$tipo/$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dato.toJson(tipo)), // Convertir el objeto a JSON aquí
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear el dato: ${response.body}");
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
