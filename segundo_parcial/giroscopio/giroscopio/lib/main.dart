import 'package:flutter/material.dart';
import 'controllers/gyroscope_controller.dart';
import 'controllers/websocket_controller.dart';
import 'views/control_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control del Computador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ControlView(), // Aquí va la vista donde controlas el giroscopio
    );
  }
}
