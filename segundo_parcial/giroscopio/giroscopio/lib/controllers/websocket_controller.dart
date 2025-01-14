import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketController {
  WebSocketChannel? _channel;
  late StreamController<bool> _connectionStatusController;
  bool _isConnected = false;

  WebSocketController() {
    _connectionStatusController = StreamController<bool>.broadcast();
  }

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  // Conectar al WebSocket
  void connect(String url) async {
    if (_isConnected) {
      print('Ya conectado al servidor.');
      return;
    }

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print('Intentando conectar al servidor en $url');

      // Escuchar mensajes del servidor para validar conexión
      _channel!.stream.listen((message) {
        print('Mensaje recibido del servidor: $message');
        if (message.contains('"status":"connected"')) {
          _isConnected = true;
          _connectionStatusController.add(true);
          print('Conexión confirmada por el servidor');
        }
      }, onError: (error) {
        _isConnected = false;
        _connectionStatusController.add(false);
        print('Error en la conexión: $error');
      }, onDone: () {
        _isConnected = false;
        _connectionStatusController.add(false);
        print('Conexión cerrada por el servidor');
      });
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
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

  void disconnect() {
    if (_channel != null) {
      _channel?.sink.close();
      _connectionStatusController.add(false);
      _isConnected = false;
    }
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
