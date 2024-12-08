import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logical/login_usuario.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil del Usuario',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _loadUserDetails(context), // Carga los detalles del usuario
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Indicador mientras carga
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se encontraron datos del usuario.'));
          }

          final userDetails = snapshot.data!;
          final username = userDetails['username'];
          final token = userDetails['token'];

          return Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Usuario: $username',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Token: $token',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, String?>> _loadUserDetails(BuildContext context) async {
    try {
      final loginController = Provider.of<UserLoginController>(context, listen: false);
      await loginController.loadUserDetails(); // Asegúrate de cargar los detalles antes de obtenerlos

      final username = loginController.username; // Accede al username
      final token = await loginController.getToken(); // Obtén el token directamente

      return {'username': username, 'token': token};
    } catch (e) {
      throw Exception("Error al cargar los detalles del usuario: $e");
    }
  }
}
