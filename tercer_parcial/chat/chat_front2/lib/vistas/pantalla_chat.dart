import 'package:flutter/material.dart';
import '../controladores/controlador_chat.dart';
import '../modelos/mensaje.dart';

class PantallaChat extends StatefulWidget {
  final String usuario;
  final String serverIp; // Agregamos la IP del servidor

  PantallaChat({required this.usuario, required this.serverIp});

  @override
  _PantallaChatState createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  late ControladorChat _controladorChat; // Inicializado en initState
  final TextEditingController _controladorMensaje = TextEditingController();
  List<Mensaje> _mensajes = [];

  @override
  void initState() {
    super.initState();
    _controladorChat =
        ControladorChat(widget.serverIp); // Usamos la IP ingresada
    _cargarMensajes();
    _controladorChat.conectarSocket((mensaje) {
      setState(() {
        _mensajes.add(mensaje);
      });
    });
  }

  @override
  void dispose() {
    _controladorChat.desconectarSocket();
    super.dispose();
  }

  void _cargarMensajes() async {
    try {
      final mensajes = await _controladorChat.obtenerMensajes();
      setState(() {
        _mensajes = mensajes;
      });
    } catch (e) {
      print('Error al cargar mensajes: $e');
    }
  }

  void _enviarMensaje() {
    if (_controladorMensaje.text.isNotEmpty) {
      final mensaje = Mensaje(
        usuario: widget.usuario,
        mensaje: _controladorMensaje.text,
        timestamp: DateTime.now().toIso8601String(),
      );
      _controladorChat.enviarMensaje(mensaje);
      _controladorMensaje.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sala de Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final msg = _mensajes[index];
                return ListTile(
                  title: Text(msg.usuario),
                  subtitle: Text(msg.mensaje),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorMensaje,
                    decoration: InputDecoration(hintText: 'Escribe un mensaje'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
