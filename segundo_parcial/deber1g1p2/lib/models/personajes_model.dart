class Personaje {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Personaje({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  // Convierte el JSON de Marvel API en un objeto Personaje
  factory Personaje.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'];
    final imageUrl = thumbnail != null
        ? "${thumbnail['path']}.${thumbnail['extension']}"
        : "https://via.placeholder.com/300x300.png?text=Sin+Imagen";

    return Personaje(
      id: json['id'].toString(),
      name: json['name'] ?? 'Nombre no disponible',
      description: json['description']?.isNotEmpty == true
          ? json['description']
          : 'Descripción no disponible para este personaje',
      imageUrl: imageUrl,
    );
  }
}
