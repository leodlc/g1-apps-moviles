import 'package:flutter/material.dart';

class Result3Screen extends StatelessWidget {
  final int numero1;
  final List<Map<String, int>> calculoMCD;

  const Result3Screen({
    Key? key,
    required this.numero1,
    required this.calculoMCD,
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
              'El M.C.D. es: $numero1 ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
