class Datos {
  final String nombre;
  final String imagen;
  final String infoAdicional;

  Datos({
    required this.nombre,
    required this.imagen,
    required this.infoAdicional,
  });

  // Constructor para JSON dinámico según tipo
  factory Datos.fromJson(Map<String, dynamic> json, String tipo) {
    switch (tipo) {
      case 'personajes':
        return Datos(
          nombre: json['nombrePersonaje'] ?? '',
          imagen: json['imagenpersonaje'] ?? '',
          infoAdicional: json['infoAdicional'] ?? '',
        );
      case 'peliculas':
        return Datos(
          nombre: json['nombrePelicula'] ?? '',
          imagen: json['imagenPelicula'] ?? '',
          infoAdicional: json['infoAdicional'] ?? '',
        );
      case 'comics':
        return Datos(
          nombre: json['nombreComic'] ?? '',
          imagen: json['imagenComic'] ?? '',
          infoAdicional: json['infoAdicional'] ?? '',
        );
      default:
        throw Exception("Tipo no válido");
    }
  }

  // Convertir a JSON según tipo
  Map<String, dynamic> toJson(String tipo) {
    switch (tipo) {
      case 'personajes':
        return {
          'nombrePersonaje': nombre,
          'imagenpersonaje': imagen,
          'infoAdicional': infoAdicional,
        };
      case 'peliculas':
        return {
          'nombrePelicula': nombre,
          'imagenPelicula': imagen,
          'infoAdicional': infoAdicional,
        };
      case 'comics':
        return {
          'nombreComic': nombre,
          'imagenComic': imagen,
          'infoAdicional': infoAdicional,
        };
      default:
        throw Exception("Tipo no válido");
    }
  }
}