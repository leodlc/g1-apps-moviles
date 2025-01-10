import 'package:flutter/material.dart';
import '../controllers/gyroscope_controller.dart';
import '../controllers/websocket_controller.dart';

class ControlView extends StatefulWidget {
  @override
  _ControlViewState createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> {
  final GyroscopeController _gyroController = GyroscopeController();
  final WebSocketController _webSocketController = WebSocketController();
  String _command = "Esperando comando...";
  String _gyroscopeData = "Sin datos"; // Para mostrar los datos del giroscopio

  @override
  void initState() {
    super.initState();
    _webSocketController.connect("ws://192.168.100.33:8080");

    // Escuchar los datos del giroscopio
    _gyroController.getGyroscopeData().listen((data) {
      // Mostrar los datos del giroscopio
      setState(() {
        _gyroscopeData =
            "X: ${data.x.toStringAsFixed(2)}, Y: ${data.y.toStringAsFixed(2)}, Z: ${data.z.toStringAsFixed(2)}";
      });

      // Detectar movimientos y enviar comandos
      if (data.x > 0.5) {
        _sendCommand('{"action": "open_url", "url": "https://www.google.com"}',
            "Abrir Google");
      } else if (data.y > 0.5) {
        _sendCommand(
            '{"action": "open_app", "command": "start winword"}', "Abrir Word");
      } else if (data.z > 0.5) {
        _sendCommand('{"action": "open_app", "command": "start wmplayer"}',
            "Abrir Reproductor Multimedia");
      }
    });
  }

  void _sendCommand(String message, String actionDescription) {
    _webSocketController.sendMessage(message);
    setState(() {
      _command = "Comando enviado: $actionDescription";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _webSocketController.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Control del Computador")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_command, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Datos del Giroscopio", style: TextStyle(fontSize: 16)),
            Text(_gyroscopeData, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
