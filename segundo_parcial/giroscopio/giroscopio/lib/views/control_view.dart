import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/gyroscope_controller.dart';
import '../controllers/websocket_controller.dart';
import 'dart:async';

class ControlView extends StatefulWidget {
  final String serverIp;

  ControlView({required this.serverIp});

  @override
  _ControlViewState createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> {
  final GyroscopeController _gyroController = GyroscopeController();
  final WebSocketController _webSocketController =
      WebSocketController(); // Ya inicializado aquí
  String _command = "Esperando comando...";
  String _gyroscopeData = "Sin datos";
  bool _canSendCommand = true;
  String _actionDescription = "";

  bool _showGoogleIcon = false;
  bool _showWordIcon = false;
  bool _showMusicIcon = false;

  List<double> _xValues = [];
  List<double> _yValues = [];
  List<double> _zValues = [];

  @override
  void initState() {
    super.initState();
    // Conectar al servidor usando el WebSocketController
    _webSocketController.connect("ws://${widget.serverIp}:8080");

    _gyroController.getGyroscopeData().listen((data) {
      _xValues.add(data.x);
      _yValues.add(data.y);
      _zValues.add(data.z);

      if (_xValues.length > 10) _xValues.removeAt(0);
      if (_yValues.length > 10) _yValues.removeAt(0);
      if (_zValues.length > 10) _zValues.removeAt(0);

      double avgX = _xValues.reduce((a, b) => a + b) / _xValues.length;
      double avgY = _yValues.reduce((a, b) => a + b) / _yValues.length;
      double avgZ = _zValues.reduce((a, b) => a + b) / _zValues.length;

      setState(() {
        _gyroscopeData =
            "X: ${avgX.toStringAsFixed(2)}, Y: ${avgY.toStringAsFixed(2)}, Z: ${avgZ.toStringAsFixed(2)}";
      });

      if (_canSendCommand) {
        if (avgX > 2.0) {
          _sendCommand(
              '{"action": "open_url", "url": "https://www.google.com"}',
              "Abrir Google");
          _toggleIcon("google");
        } else if (avgY > 2.0) {
          _sendCommand('{"action": "open_app", "command": "start winword"}',
              "Abrir Microsoft word");
          _toggleIcon("word");
        } else if (avgZ > 1.0) {
          _sendCommand('{"action": "open_app", "command": "start wmplayer"}',
              "Abrir windows media");
          _toggleIcon("music");
        }
      }
    });
  }

  void _sendCommand(String message, String actionDescription) {
    _webSocketController.sendMessage(message);
    setState(() {
      _command = "Esperando comando...";
      _actionDescription = actionDescription;
    });

    _canSendCommand = false;
    Timer(Duration(seconds: 5), () {
      _canSendCommand = true;
    });
  }

  void _toggleIcon(String iconType) {
    setState(() {
      _showGoogleIcon = iconType == "google";
      _showWordIcon = iconType == "word";
      _showMusicIcon = iconType == "music";
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _showGoogleIcon = false;
        _showWordIcon = false;
        _showMusicIcon = false;
      });
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF334155),
            ],
          ),
        ),
        child: Column(
          children: [
            Spacer(flex: 1), // Espaciador al inicio
            // Título
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    "Control del computador",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      /* fontFamily: 'Montserrat', */
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Grupo 1",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      /* fontFamily: 'Montserrat', */
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "NRC: 2512",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      /* fontFamily: 'Montserrat', */
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 2),
            // Iconos animados con contenedor de tamaño fijo
            Container(
              height: 120, // Altura fija para el área de los íconos
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _showGoogleIcon
                      ? BounceInRight(
                          child: Icon(
                            Icons.search,
                            size: 100,
                            color: Colors.red,
                          ),
                        )
                      : SizedBox(width: 100),
                  _showWordIcon
                      ? ShakeY(
                          infinite: true,
                          child: Icon(
                            Icons.description,
                            size: 100,
                            color: Colors.blue,
                          ),
                        )
                      : SizedBox(width: 100),
                  _showMusicIcon
                      ? FlipInX(
                          child: Icon(
                            Icons.music_note,
                            size: 100,
                            color: Colors.yellow,
                          ),
                        )
                      : SizedBox(width: 100),
                ],
              ),
            ),
            Spacer(flex: 1),
            // Texto alineado centrado
            Column(
              children: [
                Text(
                  _command,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                FadeIn(
                  child: Text(
                    _actionDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(56, 189, 248, 1),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Datos del Giroscopio",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _gyroscopeData,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'GaugeMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
