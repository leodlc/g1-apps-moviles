import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '/../models/comics_model.dart';

class InfoComic extends StatefulWidget {
  final Comic comic;

  const InfoComic({Key? key, required this.comic}) : super(key: key);

  @override
  _InfoComicState createState() => _InfoComicState();
}

class _InfoComicState extends State<InfoComic> {
  String descripcionTraducida = ''; // Iniciar con una cadena vacía

  @override
  void initState() {
    super.initState();
    _traducirDescripcion();
  }

  Future<void> _traducirDescripcion() async {
    final descripcion = widget.comic.description ?? ''; // Si description es null, se asigna una cadena vacía
    if (descripcion.isNotEmpty) {
      try {
        final translator = GoogleTranslator();
        final traduccion = await translator.translate(descripcion, to: 'es');
        setState(() {
          descripcionTraducida = traduccion.text;
        });
      } catch (e) {
        setState(() {
          descripcionTraducida = 'Error al traducir la descripción.';
        });
      }
    } else {
      setState(() {
        descripcionTraducida = 'Descripción no disponible para este cómic.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comic.title),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: const Icon(Icons.add),  // Este es el ícono "+"
          onPressed: () {
            // Acción que tomará el botón "+"
            print('Botón + presionado');
            // Aquí puedes agregar la navegación o acción que desees
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.comic.imageUrl,
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
                widget.comic.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              descripcionTraducida.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                descripcionTraducida,
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
