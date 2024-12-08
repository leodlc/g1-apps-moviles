import 'package:flutter/material.dart';

class Result2Screen extends StatelessWidget {
  final int numero;
  final BigInt factorial; // Cambiamos a BigInt

  const Result2Screen({
    super.key,
    required this.numero,
    required this.factorial,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado Factorial'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        color: Colors.purple[50], // Fondo suave
        padding: const EdgeInsets.all(16.0), // Márgenes más grandes
        child: Center(
          child: Card(
            elevation: 8, // Sombra de la tarjeta
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Bordes redondeados
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Espaciado interno de la tarjeta
              child: Column(
                mainAxisSize: MainAxisSize.min, // Para ajustarse al tamaño del contenido
                crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
                children: [
                  Text(
                    'Número: $numero',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Factorial: ${factorial.toString()}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Regresar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Color del botón
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
