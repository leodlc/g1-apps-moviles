import 'package:flutter/material.dart';

class Result3Screen extends StatelessWidget {
  final int numero1;
  final List<Map<String, int>> calculoMCD;

  const Result3Screen({
    super.key,
    required this.numero1,
    required this.calculoMCD,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'El M.C.D. es: $numero1 ',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: calculoMCD.length,
                itemBuilder: (context, index) {
                  final factorMCD = calculoMCD[index]['MCD']!;
                  return ListTile(
                    title: Text('Resultado:  $factorMCD'),
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
