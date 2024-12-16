import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/peliculas_model.dart';

class PeliculasController {
  final String _baseUrl = 'https://mcuapi.herokuapp.com/api/v1/movies';

  // Método para obtener todas las películas
  Future<List<PeliculasModel>> obtenerPeliculas() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((movie) => PeliculasModel.fromJson(movie)).toList();
    } else {
      throw Exception("Error al obtener películas: ${response.statusCode}");
    }
  }
}
