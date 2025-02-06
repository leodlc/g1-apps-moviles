class Mensaje {
  final String usuario;
  final String mensaje;
  final String timestamp; // <-- Agregamos timestamp como String

  Mensaje(
      {required this.usuario, required this.mensaje, required this.timestamp});

  // Convertir JSON a un objeto Mensaje
  factory Mensaje.desdeJson(Map<String, dynamic> json) {
    print("🔍 JSON antes de procesar: $json"); // <-- Para depuración

    return Mensaje(
      usuario: json['usuario'] ?? json['username'] ?? 'Desconocido',
      mensaje: json['mensaje'] ?? json['message'] ?? '',
      timestamp: json['timestamp']?.toString() ??
          'Sin fecha', // <-- Convertimos timestamp en String
    );
  }

  // Convertir un objeto Mensaje a JSON
  Map<String, dynamic> aJson() {
    return {
      'usuario': usuario,
      'mensaje': mensaje,
      'timestamp': timestamp,
    };
  }
}
