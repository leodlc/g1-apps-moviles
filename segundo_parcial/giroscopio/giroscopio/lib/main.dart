import 'package:flutter/material.dart';
import 'views/control_view.dart';
import 'views/server_config_dialog.dart';

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
      home: AppLauncher(),
    );
  }
}

class AppLauncher extends StatefulWidget {
  @override
  _AppLauncherState createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  String? _serverIp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showServerConfigDialog();
    });
  }

  void _showServerConfigDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Impedir cerrar sin conectar
      builder: (context) => ServerConfigDialog(
        onConnect: (ip) {
          setState(() {
            _serverIp = ip;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _serverIp == null
        ? Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F172A), // Azul oscuro
                    Color(0xFF1E293B), // Azul intermedio
                    Color(0xFF334155), // Azul claro
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "Conectando...",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        : ControlView(serverIp: _serverIp!);
  }
}
