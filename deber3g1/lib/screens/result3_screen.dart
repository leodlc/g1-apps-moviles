import 'package:flutter/material.dart';

class Result3Screen extends StatelessWidget {
  final int numero1;
  final int numero2;
  final List<Map<String, int>> resultado;

  const Result3Screen({
    super.key,
    required this.numero1,
    required this.numero2,
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    // Extraer el MCD del resultado
    final mcd = resultado.isNotEmpty ? resultado[0]['MCD'] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado del MCD'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'El MCD de $numero1 y $numero2 es:',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    mcd != null ? '$mcd' : 'Error al calcular el MCD',
                    style: const TextStyle(fontSize: 36, color: Colors.indigo),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    child: const Text('Volver'),
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
