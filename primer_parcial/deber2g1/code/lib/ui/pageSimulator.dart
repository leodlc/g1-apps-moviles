import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logical/login_usuario.dart';
import 'formulario_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final loginController =
                  Provider.of<UserLoginController>(context, listen: false);
              await loginController.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const UserLoginForm()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadUserDetailsAndUsers(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los datos: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No se encontraron datos del usuario.'),
            );
          }

          final userDetails = snapshot.data!;
          final username = userDetails['username'];
          final token = userDetails['token'];
          final users = userDetails['users'] as List<Map<String, dynamic>>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Card(
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
                  const SizedBox(height: 20),
                  const Text(
                    'Usuarios Registrados:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(user['username'] ?? 'Sin nombre'),
                        subtitle:
                            Text('Email: ${user['email'] ?? 'Sin email'}'),
                        trailing: Text('ID: ${user['id'] ?? '-'}'),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadUserDetailsAndUsers(
      BuildContext context) async {
    try {
      final loginController =
          Provider.of<UserLoginController>(context, listen: false);
      await loginController.loadUserDetails();

      final username = loginController.username;
      final token = await loginController.getToken();
      final users =
          await loginController.getUsers(); // Ajusta para obtener usuarios.

      return {'username': username, 'token': token, 'users': users};
    } catch (e) {
      throw Exception("Error al cargar los detalles del usuario: $e");
    }
  }
}
