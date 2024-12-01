import 'package:flutter/material.dart';
import '../../logical/crud_usuario.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = UserCrudController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _controller.getUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Username: ${user['username']}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text("Email: ${user['email']}",
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
