import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserLoginController extends ChangeNotifier {
  final String apiLoginUrl =
      'http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/login'; // URL de inicio de sesión
  final String apiUsersUrl =
      'http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/users'; // URL para obtener usuarios
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _username;

  String? get username => _username;

  /// Envía los datos de inicio de sesión al backend
  Future<Map<String, dynamic>> submitUserLoginData(
      Map<String, String> userData) async {
    try {
      final response = await http.post(
        Uri.parse(apiLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          _username = userData['username'];
          await _storage.write(key: 'auth_token', value: responseData['token']);
          await _storage.write(key: 'username', value: _username);
          notifyListeners();

          return {
            'success': true,
            'message': responseData['message'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Error desconocido',
          };
        }
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Usuario no existe',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message':
              'Credenciales incorrectas. Por favor, verifica tu usuario y contraseña.',
        };
      } else {
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al conectarse: $e',
      };
    }
  }

  /// Obtiene el token almacenado
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Cierra sesión y borra el token
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'username');
    _username = null;
    notifyListeners();
  }

  /// Carga los detalles del usuario almacenados localmente
  Future<void> loadUserDetails() async {
    _username = await _storage.read(key: 'username');
    notifyListeners();
  }

  /// Obtiene la lista de usuarios desde el backend
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("No se encontró el token de autenticación.");
      }

      final response = await http.get(
        Uri.parse(apiUsersUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final users = responseData['data'] as List<dynamic>;
        return List<Map<String, dynamic>>.from(users);
      } else {
        throw Exception('Error al obtener usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }
}
