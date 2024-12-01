import 'package:flutter/material.dart';
import '../../logical/crud_usuario.dart';

class AdminCreacionUsuario extends StatefulWidget {
  const AdminCreacionUsuario({Key? key}) : super(key: key);

  @override
  State<AdminCreacionUsuario> createState() => _AdminCreacionUsuarioState();
}

class _AdminCreacionUsuarioState extends State<AdminCreacionUsuario> {
  final UserCrudController _userController = UserCrudController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _crearUsuario() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final exito = await _userController.createUser({
        'username': username,
        'email': email,
        'password': password,
      });

      if (exito) {
        Navigator.of(context).pop(true); // Devuelve un resultado de éxito
      } else {
        throw Exception('Error al crear el usuario.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Crear Nuevo Usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _crearUsuario,
                    child: const Text('Crear Usuario'),
                  ),
          ],
        ),
      ),
    );
  }
}
