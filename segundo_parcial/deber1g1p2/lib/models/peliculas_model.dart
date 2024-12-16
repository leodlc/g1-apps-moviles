class PeliculasModel {
  final String title;
  final String coverUrl;
  final String overview;
  final String releaseDate;

  PeliculasModel({
    required this.title,
    required this.coverUrl,
    required this.overview,
    required this.releaseDate,
  });

  factory PeliculasModel.fromJson(Map<String, dynamic> json) {
    return PeliculasModel(
      title: json['title'] ?? 'Sin título',
      coverUrl: json['cover_url'] ?? '',
      overview: json['overview'] ?? 'No hay descripción disponible.',
      releaseDate: json['release_date'] ?? 'Fecha no especificada',
    );
  }
}
