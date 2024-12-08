import 'package:flutter/material.dart';

class Result1Screen extends StatelessWidget {
  final String character;
  final int asciiValue;

  const Result1Screen({
    super.key,
    required this.character,
    required this.asciiValue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado ASCII')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Carácter: $character',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Valor ASCII: $asciiValue',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
