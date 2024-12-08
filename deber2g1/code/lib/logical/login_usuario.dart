import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLoginController {
  final String apiUrl = 'http://localhost:8012/login'; //URL

  // Validación de campos
  bool validadorCamposLogin(String userLogin, String passwordLogin) {
    if (userLogin.isEmpty || passwordLogin.isEmpty) return false;
    if (passwordLogin.length < 6) return false;
    return true;
  }

  // Enviar datos de inicio de sesión al backend
  Future<bool> submitUserLoginData(Map<String, String> userData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          await saveToken(responseData['token']); // Guardar el token
          return true;
        } else {
          print('Error: ${responseData['message']}');
          return false;
        }
      } else {
        print('Error del servidor: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al conectarse: $e');
      return false;
    }
  }

  // Guardar el token
  Future<void> saveToken(String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'auth_token', value: token);
  }
}
