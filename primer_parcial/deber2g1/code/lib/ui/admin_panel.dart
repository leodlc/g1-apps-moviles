import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdminPanel extends StatefulWidget {
  final String token; // Token para autenticación

  const AdminPanel({super.key, required this.token});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Future<List<Map<String, dynamic>>> _userListFuture;

  @override
  void initState() {
    super.initState();
    _userListFuture = _fetchUsers();
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final users = List<Map<String, dynamic>>.from(responseData['data']);

        // Filtrar al usuario admin
        return users
            .where((user) => user['username'].toLowerCase() != 'admin')
            .toList();
      } else {
        throw Exception(
            'Error al cargar usuarios: ${response.body} (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> _showCreateUserDialog(BuildContext context) async {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final userData = {
                'username': usernameController.text,
                'email': emailController.text,
                'password': passwordController.text,
              };

              try {
                final response = await http.post(
                  Uri.parse(
                      'http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/users'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${widget.token}',
                  },
                  body: jsonEncode(userData),
                );

                if (response.statusCode == 201 || response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Usuario creado exitosamente')),
                  );
                  Navigator.of(context).pop(true);
                } else {
                  final errorData = jsonDecode(response.body);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        errorData['message'] ?? 'Error al crear el usuario',
                      ),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Fondo verde
            ),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        _userListFuture = _fetchUsers();
      });
    }
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel de Administración',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(
              side: const BorderSide(
                  color: Colors.green, width: 2), // Borde verde
              backgroundColor: Colors.white, // Fondo blanco
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.green),
            label: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.green),
            ),
          ),
          ElevatedButton(
            onPressed: () => _showCreateUserDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Fondo verde
              shape: const CircleBorder(), // Botón circular
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay usuarios disponibles',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final userList = snapshot.data!;

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(user['username']),
                  subtitle: Text(user['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.green,
                        onPressed: () {
                          // Lógica de edición aquí
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () async {
                          try {
                            final response = await http.delete(
                              Uri.parse(
                                  'http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/users/${user['id']}'),
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer ${widget.token}',
                              },
                            );

                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Usuario eliminado exitosamente')),
                              );
                              setState(() {
                                _userListFuture = _fetchUsers();
                              });
                            } else {
                              final errorData = jsonDecode(response.body);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    errorData['message'] ??
                                        'Error al eliminar usuario',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
