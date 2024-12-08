import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart'; // Necesario para ChangeNotifier

class UserLoginController extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;
  String? _username;

  final String apiUrl = 'http://localhost:8012/login'; //URL

  // Validación de campos
  bool validadorCamposLogin(String userLogin, String passwordLogin) {
    if (userLogin.isEmpty || passwordLogin.isEmpty) return false;
    if (passwordLogin.length < 6) return false;
    return true;
  }

  // Cargar nombre de usuario y token desde almacenamiento seguro
  Future<void> loadUserDetails() async {
    _username = await _storage.read(key: 'username');
    _token = await _storage.read(key: 'auth_token');
    notifyListeners(); // Notifica cuando se cargan los detalles
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
          // Asegurarse de que username no sea null antes de guardarlo
          String username = userData['username'] ?? 'Usuario no disponible';  // Valor por defecto si es nulo
          await saveUsername(username);  // Guardar el nombre de usuario

          String token = responseData['token'];
          await saveToken(token); // Guardar el token

          notifyListeners(); // Notificar a los listeners cuando se haya guardado el token
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

  // Método para guardar el nombre de usuario de forma segura
  Future<void> saveUsername(String username) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'username', value: username);
  }

  // Guardar el token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Método para obtener el token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Método para obtener el nombre de usuario
  String? get username => _username;

  // Configura el nombre de usuario (puedes ajustar este método según tu lógica)
  set username(String? username) {
    _username = username;
    notifyListeners(); // Notifica a los listeners cuando se ha configurado el nombre de usuario
  }
}
