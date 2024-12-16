import 'package:flutter/material.dart';
import '/models/peliculas_model.dart';
import 'package:translator/translator.dart';

class InfoPelicula extends StatefulWidget {
  final PeliculasModel pelicula;

  const InfoPelicula({Key? key, required this.pelicula}) : super(key: key);

  @override
  _InfoPeliculaState createState() => _InfoPeliculaState();
}

class _InfoPeliculaState extends State<InfoPelicula> {
  String? sinopsisTraducida;
  String? tituloTrad;

  @override
  void initState() {
    super.initState();
    _traducirSinopsis();
  }

  Future<void> _traducirSinopsis() async {
    try {
      final translator = GoogleTranslator();
      final traducida =
      await translator.translate(widget.pelicula.overview, to: 'es');
      final tituloTraducido =
      await translator.translate(widget.pelicula.title, to: 'es');
      setState(() {
        sinopsisTraducida = traducida.text;
        tituloTrad = tituloTraducido.text;
      });
    } catch (e) {
      setState(() {
        sinopsisTraducida = 'Error al traducir la sinopsis.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pelicula.title),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.pelicula.coverUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 150,
                      color: Colors.white70,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.pelicula.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Fecha de lanzamiento: ${widget.pelicula.releaseDate}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sinopsis:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              sinopsisTraducida == null
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                sinopsisTraducida!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF151313),
    );
  }
}
