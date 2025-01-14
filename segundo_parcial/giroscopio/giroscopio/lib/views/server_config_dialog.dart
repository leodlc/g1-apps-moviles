import 'package:flutter/material.dart';
import 'dart:async';
import '../controllers/websocket_controller.dart';

class ServerConfigDialog extends StatefulWidget {
  final Function(String) onConnect;

  ServerConfigDialog({required this.onConnect});

  @override
  _ServerConfigDialogState createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<ServerConfigDialog> {
  final TextEditingController _ipController = TextEditingController();
  final WebSocketController _webSocketController = WebSocketController();
  String? _errorMessage;
  bool _isConnecting = false;
  late StreamSubscription<bool> _connectionSubscription;

  void _connect() {
    String ip = _ipController.text.trim();
    if (ip.isNotEmpty) {
      setState(() {
        _isConnecting = true;
        _errorMessage = null;
      });

      // Conectar al servidor WebSocket
      _webSocketController.connect("ws://$ip:8080");

      // Escuchar el estado de la conexión
      _connectionSubscription = _webSocketController.connectionStatus.listen(
        (isConnected) {
          if (isConnected) {
            widget.onConnect(ip); // Notificar al padre
            _connectionSubscription.cancel();
            Navigator.of(context).pop(); // Cerrar el diálogo
          } else {
            setState(() {
              _isConnecting = false;
              _errorMessage =
                  "No se ha podido conectar. Asegúrate de que el servidor y el dispositivo estén en la misma red.";
            });
          }
        },
      );
    } else {
      setState(() {
        _errorMessage = "La IP no puede estar vacía.";
      });
    }
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    _webSocketController.dispose(); // Liberar recursos del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(30, 41, 59, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        "Configurar Servidor",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Introduce la IP del servidor WebSocket:",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _ipController,
            decoration: InputDecoration(
              hintText: "Ejemplo: 192.168.1.100",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color.fromRGBO(51, 65, 85, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
          if (_isConnecting) ...[
            SizedBox(height: 10),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _isConnecting ? null : _connect,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(14, 165, 233, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            _isConnecting ? "Conectando..." : "Conectar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
