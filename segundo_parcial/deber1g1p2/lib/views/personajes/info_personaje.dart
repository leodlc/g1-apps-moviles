import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '/../models/personajes_model.dart';

class InfoPersonaje extends StatefulWidget {
  final Personaje personaje;

  const InfoPersonaje({Key? key, required this.personaje}) : super(key: key);

  @override
  _InfoPersonajeState createState() => _InfoPersonajeState();
}

class _InfoPersonajeState extends State<InfoPersonaje> {
  String? descripcionTraducida;

  @override
  void initState() {
    super.initState();
    _traducirDescripcion();
  }

  Future<void> _traducirDescripcion() async {
    if (widget.personaje.description.isNotEmpty) {
      try {
        final translator = GoogleTranslator();
        final traduccion = await translator.translate(widget.personaje.description, to: 'es');
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
        descripcionTraducida = 'Descripción no disponible para este personaje.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personaje.name),
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
                  widget.personaje.imageUrl,
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
                widget.personaje.name,
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
              descripcionTraducida == null
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                descripcionTraducida!,
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
