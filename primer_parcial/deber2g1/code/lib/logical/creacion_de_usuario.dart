import 'dart:convert';
import 'package:http/http.dart' as http;

class UserCreationController {
  final String apiUrl = 'http://localhost:8012/users'; // URL de tu backend

  Future<Map<String, dynamic>> submitUserData(
      Map<String, String> userData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'],
        };
      } else {
        // Manejar errores en el cuerpo de la respuesta
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Error al crear el usuario',
        };
      }
    } catch (e) {
      // Manejo de excepciones de red u otros errores
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}
