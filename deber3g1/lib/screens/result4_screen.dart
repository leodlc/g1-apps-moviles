import 'package:flutter/material.dart';

class Result4Screen extends StatelessWidget {
  final int numero;
  final List<Map<String, int>> factorizacion;

  const Result4Screen({
    Key? key,
    required this.numero,
    required this.factorizacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'La factorización de $numero es:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: factorizacion.length,
                itemBuilder: (context, index) {
                  final factor = factorizacion[index]['factor']!;
                  final potencia = factorizacion[index]['potencia']!;
                  return ListTile(
                    title: Text('Factor $factor'),
                    subtitle: Text('Potencia $potencia'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
