import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../modelos/mensaje.dart';

class ControladorChat {
  final String serverIp;
  late final String apiUrl;
  late final String socketUrl;
  IO.Socket? socket;

  ControladorChat(this.serverIp) {
    apiUrl = 'http://$serverIp:3000/messages';
    socketUrl = 'http://$serverIp:3000';
  }

  // Conectar al servidor Socket.IO con reconexión controlada
  void conectarSocket(Function alRecibirMensaje) {
    if (socket != null && socket!.connected) {
      print("El WebSocket ya está conectado, no se reiniciará.");
      return;
    }

    socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("Conectado al servidor WebSocket en $socketUrl");
    });

    socket!.on('receiveMessage', (data) {
      print("Mensaje recibido desde el servidor: $data");
      try {
        final mensaje = Mensaje.desdeJson(data);
        alRecibirMensaje(mensaje);
      } catch (e) {
        print("❌ Error al procesar el mensaje: $e");
      }
    });

    socket!.onDisconnect((_) {
      print("Desconectado del servidor WebSocket");
    });

    socket!.onError((error) {
      print("Error en WebSocket: $error");
    });
  }

  // Desconectar completamente el WebSocket
  void desconectarSocket() {
    if (socket != null) {
      print("Desconectando WebSocket...");
      socket!.disconnect();
      socket!.dispose();
      socket = null;
      print("WebSocket desconectado completamente.");
    }
  }

  // Obtener mensajes desde el servidor
  Future<List<Mensaje>> obtenerMensajes() async {
    try {
      final respuesta = await http.get(Uri.parse(apiUrl));
      if (respuesta.statusCode == 200) {
        final List decodificado = json.decode(respuesta.body);
        return decodificado.map((data) => Mensaje.desdeJson(data)).toList();
      } else {
        throw Exception('Error al obtener los mensajes');
      }
    } catch (e) {
      print("Error al obtener mensajes: $e");
      return [];
    }
  }

  // Enviar un mensaje (solo si el socket está conectado)
  void enviarMensaje(Mensaje mensaje) {
    if (socket != null && socket!.connected) {
      socket!.emit('sendMessage', mensaje.aJson());
    } else {
      print("No se puede enviar el mensaje: No hay conexión con el servidor.");
    }
  }
}
