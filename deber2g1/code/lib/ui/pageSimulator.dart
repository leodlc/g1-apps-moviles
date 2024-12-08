import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar Provider
import '../../logical/login_usuario.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String? _username;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  // Método para cargar detalles del usuario desde el controlador
  Future<void> _loadUserDetails() async {
    final loginController = Provider.of<UserLoginController>(context, listen: false);
  }

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
      body: Center(
        child: _username == null || _token == null
            ? const CircularProgressIndicator() // Muestra un indicador mientras se cargan los datos
            : Card(
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
                  'Usuario: $_username',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Token: $_token',
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
      ),
    );
  }
}
