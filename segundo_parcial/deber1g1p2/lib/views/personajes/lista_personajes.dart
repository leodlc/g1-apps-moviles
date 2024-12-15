import 'package:flutter/material.dart';

class ListaPersonajes extends StatelessWidget {
  const ListaPersonajes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PERSONAJES',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF151313), // Fondo negro personalizado
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color:
              Color(0xFF852221), // Color personalizado para el botón regresar
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'PERSONAJES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF151313), // Fondo negro personalizado
    );
  }
}
