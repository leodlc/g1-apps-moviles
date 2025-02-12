import 'package:flutter/material.dart';
import 'pantalla_chat.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Para detectar si es Web o Android
import 'package:lottie/lottie.dart'; // Importamos Lottie

class PantallaLogin extends StatefulWidget {
  @override
  _PantallaLoginState createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController controladorUsuario = TextEditingController();
  final TextEditingController controladorIp = TextEditingController();
  bool _isLoading = false; // Estado de carga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para una apariencia limpia
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // **Título**
              Text(
                "Grupo 1 - Chat Grupal",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // **Animación Lottie**
              Lottie.asset(
                'assets/icon.json', // Ruta del archivo JSON dentro de assets
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),

              // **Campo Usuario**
              TextField(
                controller: controladorUsuario,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
              ),
              SizedBox(height: 10),

              // **Campo IP del Servidor**
              TextField(
                controller: controladorIp,
                decoration: InputDecoration(
                  labelText: 'IP del Servidor',
                  hintText: 'Ejemplo: 192.168.100.33',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
              ),
              SizedBox(height: 20),

              // **Botón de Entrar**
              SizedBox(
                width: double.infinity, // Ocupa todo el ancho disponible
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (controladorUsuario.text.isNotEmpty &&
                              controladorIp.text.isNotEmpty) {
                            String username = controladorUsuario.text.trim();
                            String serverIp = controladorIp.text.trim();

                            // Mostrar spinner de carga
                            setState(() {
                              _isLoading = true;
                            });
                            _mostrarDialogoCarga(context);

                            // Guardar usuario en la base de datos antes de registrar el token
                            bool usuarioGuardado =
                                await registrarUsuarioEnServidor(
                                    serverIp, username);
                            if (!usuarioGuardado) {
                              print("Error al registrar usuario.");
                              _cerrarDialogoCarga();
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }

                            // Configurar FCM y registrar el token con la IP correcta
                            if (kIsWeb) {
                              await configurarFCMWeb(
                                  context, username, serverIp);
                            } else {
                              await configurarFCMAndroid(
                                  context, username, serverIp);
                            }

                            // Cerrar spinner y navegar a la pantalla de chat
                            _cerrarDialogoCarga();
                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaChat(
                                  usuario: username,
                                  serverIp: serverIp,
                                ),
                              ),
                            );
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Entrar',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Muestra un diálogo de carga mientras se espera la conexión**
  void _mostrarDialogoCarga(BuildContext context) {
    showDialog(
      barrierDismissible:
          false, // Evita que el usuario cierre el diálogo manualmente
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text("Conectando a la sala de chat..."),
            ],
          ),
        );
      },
    );
  }

  /// **Cierra el diálogo de carga**
  void _cerrarDialogoCarga() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// **Registra el usuario en la base de datos antes de registrar el token**
  Future<bool> registrarUsuarioEnServidor(
      String serverIp, String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIp:3000/register-user'),
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
