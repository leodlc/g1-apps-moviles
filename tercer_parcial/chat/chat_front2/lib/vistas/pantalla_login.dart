import 'package:flutter/material.dart';
import 'pantalla_chat.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Para detectar si es Web o Android

class PantallaLogin extends StatelessWidget {
  final TextEditingController controladorUsuario = TextEditingController();
  final TextEditingController controladorIp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sala de Chat - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controladorUsuario,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controladorIp,
              decoration: InputDecoration(
                labelText: 'IP del Servidor',
                hintText: 'Ejemplo: 192.168.100.33',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (controladorUsuario.text.isNotEmpty &&
                    controladorIp.text.isNotEmpty) {
                  String username = controladorUsuario.text.trim();
                  String serverIp = controladorIp.text.trim();

                  // Guardar usuario en la base de datos antes de registrar el token
                  bool usuarioGuardado =
                      await registrarUsuarioEnServidor(serverIp, username);
                  if (!usuarioGuardado) {
                    print("Error al registrar usuario.");
                    return;
                  }

                  // Configurar FCM y registrar el token con la IP correcta
                  if (kIsWeb) {
                    await configurarFCMWeb(context, username, serverIp);
                  } else {
                    await configurarFCMAndroid(context, username, serverIp);
                  }

                  // Navegar a la pantalla de chat con el usuario correcto
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaChat(
                        usuario: username,
                        serverIp: serverIp, // Pasamos la IP del servidor
                      ),
                    ),
                  );
                }
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  /// **Registra el usuario en la base de datos antes de registrar el token**
  Future<bool> registrarUsuarioEnServidor(
      String serverIp, String username) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://$serverIp:3000/register-user'), // IP dinámica ingresada por el usuario
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": username}),
      );

      if (response.statusCode == 200) {
        print("Usuario registrado correctamente.");
        return true;
      } else {
        print("Error al registrar usuario: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de conexión al registrar usuario: $e");
      return false;
    }
  }
}
