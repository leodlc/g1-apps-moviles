import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketController {
  WebSocketChannel? _channel;

  // Conectar al WebSocket
  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print('Conexión establecida con $url');
    } catch (e) {
      print('Error al conectar al WebSocket: $e');
    }
  }

  // Enviar mensaje
  void sendMessage(String message) {
    if (_channel != null) {
      try {
        _channel!.sink.add(message);
        print('Mensaje enviado: $message');
      } catch (e) {
        print('Error al enviar mensaje: $e');
      }
    } else {
      print('No se puede enviar el mensaje. WebSocket no está conectado.');
    }
  }

  // Escuchar mensajes del WebSocket
  Stream<String> get messages => _channel!.stream.map((message) {
        print('Mensaje recibido del servidor: $message');
        return message.toString();
      });

  // Cerrar la conexión
  void disconnect() {
    if (_channel != null) {
      try {
        _channel?.sink.close();
        print('Conexión WebSocket cerrada');
      } catch (e) {
        print('Error al cerrar la conexión: $e');
      }
    } else {
      print('No hay conexión WebSocket para cerrar.');
    }
  }
}
