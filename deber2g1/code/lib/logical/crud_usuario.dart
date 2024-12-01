import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserCrudController extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      // AQUI AGREGAN UN ARCHIVO .env con la ip de sus máquinas y el puerto de su servidor xampp
      baseUrl:
          "http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/users/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  // Lista de usuarios observable
  ValueNotifier<List<Map<String, dynamic>>> userListNotifier =
      ValueNotifier([]);

  /// Obtener todos los usuarios
  Future<void> getAllUsers() async {
    try {
      final response = await _dio.get('/');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List<dynamic>;
        userListNotifier.value = List<Map<String, dynamic>>.from(data);
        notifyListeners();
      } else {
        throw Exception("Formato inesperado en la respuesta del servidor.");
      }
    } on DioException catch (e) {
      throw Exception("Error al cargar los usuarios: ${_handleError(e)}");
    }
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    try {
      final response = await _dio.get('/$id');
      if (response.statusCode == 200 && response.data != null) {
        return Map<String, dynamic>.from(response.data);
      }
      throw Exception("Usuario no encontrado o respuesta inesperada.");
    } on DioException catch (e) {
      throw Exception("Error al obtener el usuario: ${_handleError(e)}");
    }
  }

  /// Crear un usuario
  Future<bool> createUser(Map<String, String> userData) async {
    try {
      final response = await _dio.post('/', data: userData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['message'] == "User created successfully") {
          // Recargar la lista después de crear el usuario
          await getAllUsers();

          return true; // Usuario creado exitosamente
        } else {
          notifyListeners();
          throw Exception('Respuesta inesperada del servidor');
        }
      } else {
        throw Exception(
            'Error al crear usuario: Código ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// Eliminar un usuario por ID
  Future<bool> deleteUser(String id) async {
    try {
      final response = await _dio.delete('/$id');
      if (response.statusCode == 200) {
        // Recargar la lista después de eliminar el usuario
        await getAllUsers();
        notifyListeners();
        return true;
      }
      throw Exception("Error al eliminar el usuario.");
    } on DioException catch (e) {
      throw Exception("Error al eliminar el usuario: ${_handleError(e)}");
    }
  }

  /// Actualizar un usuario por ID
  /// Actualizar un usuario por ID
  Future<bool> updateUser(String id, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put(
        '/$id',
        data: updatedData,
      );
      if (response.statusCode == 200) {
        // Actualiza localmente la lista de usuarios
        final updatedUser = response.data[
            'data']; // Suponiendo que la API devuelve el usuario actualizado
        final index =
            userListNotifier.value.indexWhere((user) => user['id'] == id);

        if (index != -1) {
          userListNotifier.value[index] =
              Map<String, dynamic>.from(updatedUser);
          notifyListeners();
          // Notifica cambios a la UI
        }
        return true;
      }
      throw Exception("Error al actualizar el usuario.");
    } on DioException catch (e) {
      throw Exception("Error al actualizar el usuario: ${_handleError(e)}");
    }
  }

  /// Manejo de errores
  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ??
          "Error del servidor: ${e.response?.statusCode}";
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return "Error de conexión: Tiempo de espera excedido.";
    } else if (e.type == DioExceptionType.badResponse) {
      return "Respuesta inválida del servidor: ${e.response?.statusCode}";
    } else {
      return "Error inesperado: ${e.message}";
    }
  }
}
