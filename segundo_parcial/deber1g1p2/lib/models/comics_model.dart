class Comic {
  final int id;
  final String title;
  final String? description;
  final String imageUrl;

  Comic({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'];
    final imageUrl = '${thumbnail['path']}.${thumbnail['extension']}';

    return Comic(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? 'Comic de Marvel',
      imageUrl: imageUrl,
    );
  }
}
