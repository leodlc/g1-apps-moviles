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

  factory Personaje.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'];
    return Personaje(
      id: json['id'].toString(),
      name: json['name'] ?? 'Sin nombre',
      description: json['description']?.isNotEmpty == true
          ? json['description']
          : 'Sin descripción',
      imageUrl: '${thumbnail['path']}.${thumbnail['extension']}',
    );
  }
}
