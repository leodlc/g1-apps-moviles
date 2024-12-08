import 'dart:convert';
import 'package:http/http.dart' as http;

class UserCreationController {
  final String apiUrl = 'http://localhost:8012/users/'; // URL de tu API

  Future<bool> submitUserData(Map<String, String> userData) async {
    try {
      // Realizamos la solicitud POST con los datos del usuario
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData), // Convertimos el Map a JSON
      );

      // Verificamos si la respuesta es válida (statusCode 200)
      if (response.statusCode == 200) {
        try {
          // Intentamos parsear el cuerpo de la respuesta como JSON
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            return true; // Usuario creado exitosamente
          } else {
            print('Error al crear el usuario: ${responseData['message']}');
            return false;
          }
        } catch (e) {
          // Si ocurre un error al parsear el JSON, mostramos el error
          print('Respuesta no es JSON: ${response.body}');
          return false;
        }
      } else {
        print('Error del servidor: ${response.statusCode}');
        return false; // Hubo un error con la petición
      }
    } catch (e) {
      print('Excepción al conectarse: $e');
      return false; // Error en la conexión
    }
  }
}
