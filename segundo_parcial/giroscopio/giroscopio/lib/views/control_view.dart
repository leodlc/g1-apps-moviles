import 'package:flutter/material.dart';
import '../controllers/gyroscope_controller.dart';
import '../controllers/websocket_controller.dart';
import 'dart:async'; // Necesario para controlar el tiempo de espera

class ControlView extends StatefulWidget {
  @override
  _ControlViewState createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> {
  final GyroscopeController _gyroController = GyroscopeController();
  final WebSocketController _webSocketController = WebSocketController();
  String _command = "Esperando comando...";
  String _gyroscopeData = "Sin datos"; // Para mostrar los datos del giroscopio
  bool _canSendCommand = true; // Control para evitar múltiples envíos

  // Listas para promediar los valores
  List<double> _xValues = [];
  List<double> _yValues = [];
  List<double> _zValues = [];

  @override
  void initState() {
    super.initState();
    _webSocketController.connect("ws://192.168.100.33:8080");

    // Escuchar los datos del giroscopio
    _gyroController.getGyroscopeData().listen((data) {
      // Agregar valores actuales a las listas
      _xValues.add(data.x);
      _yValues.add(data.y);
      _zValues.add(data.z);

      // Mantener solo los últimos 10 valores
      if (_xValues.length > 10) _xValues.removeAt(0);
      if (_yValues.length > 10) _yValues.removeAt(0);
      if (_zValues.length > 10) _zValues.removeAt(0);

      // Calcular los promedios
      double avgX = _xValues.reduce((a, b) => a + b) / _xValues.length;
      double avgY = _yValues.reduce((a, b) => a + b) / _yValues.length;
      double avgZ = _zValues.reduce((a, b) => a + b) / _zValues.length;

      // Mostrar los valores promedio
      setState(() {
        _gyroscopeData =
            "X: ${avgX.toStringAsFixed(2)}, Y: ${avgY.toStringAsFixed(2)}, Z: ${avgZ.toStringAsFixed(2)}";
      });

      // Detectar movimientos y enviar comandos con aplicaciones livianas
      if (_canSendCommand) {
        if (avgX > 2.0) {
          _sendCommand(
              '{"action": "open_url", "url": "https://www.google.com"}',
              "Abrir Google");
        } else if (avgY > 2.0) {
          _sendCommand('{"action": "open_app", "command": "notepad"}',
              "Abrir Bloc de Notas");
        } else if (avgZ > 2.0) {
          _sendCommand(
              '{"action": "open_app", "command": "calc"}', "Abrir Calculadora");
        }
      }
    });
  }

  void _sendCommand(String message, String actionDescription) {
    _webSocketController.sendMessage(message);
    setState(() {
      _command = "Comando enviado: $actionDescription";
    });

    // Bloquear nuevos comandos durante 10 segundos
    _canSendCommand = false;
    Timer(Duration(seconds: 5), () {
      _canSendCommand = true; // Reactivar después de 10 segundos
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
