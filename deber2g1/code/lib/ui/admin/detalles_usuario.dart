import 'package:flutter/material.dart';
import '../../logical/crud_usuario.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = UserCrudController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: controller.getUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Indicador de carga
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Manejo de errores
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No se encontraron datos del usuario."));
          }

          final user = snapshot.data!; // Obtenemos los datos del usuario

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Username: ${user['username'] ?? 'No disponible'}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text("Email: ${user['email'] ?? 'No disponible'}",
                    style: const TextStyle(fontSize: 18)),
                // Agrega más información si es necesario
              ],
            ),
          );
        },
      ),
    );
  }
}
