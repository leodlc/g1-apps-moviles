// lib/controladores/controlador_chat.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../modelos/mensaje.dart';

class ControladorChat {
  final String apiUrl = 'http://localhost:3000/messages';
  final String socketUrl = 'http://localhost:3000';
  IO.Socket? socket;

  // Conectar al servidor Socket.IO
  void conectarSocket(Function alRecibirMensaje) {
    socket = IO.io(
        socketUrl, IO.OptionBuilder().setTransports(['websocket']).build());
    socket!.on('receiveMessage', (data) {
      // 🔍 Imprimir los datos recibidos en la consola de Flutter
      print('📥 Datos recibidos del servidor en Flutter: $data');

      try {
        final mensaje = Mensaje.desdeJson(data);
        alRecibirMensaje(mensaje);
      } catch (e) {
        print('❌ Error al procesar el mensaje: $e');
      }
    });
  }

  // Desconectar el socket
  void desconectarSocket() {
    socket?.disconnect();
  }

  // Obtener mensajes desde el servidor
  Future<List<Mensaje>> obtenerMensajes() async {
    final respuesta = await http.get(Uri.parse(apiUrl));
    if (respuesta.statusCode == 200) {
      final List decodificado = json.decode(respuesta.body);
      return decodificado.map((data) => Mensaje.desdeJson(data)).toList();
    } else {
      throw Exception('Error al obtener los mensajes');
    }
  }

  // Enviar un mensaje
  void enviarMensaje(Mensaje mensaje) {
    socket?.emit('sendMessage', mensaje.aJson());
  }
}
