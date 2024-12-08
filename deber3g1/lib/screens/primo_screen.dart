import 'package:flutter/material.dart';
import '../logic/primo_logic.dart';
import 'result5_screen.dart';

class PrimeScreen extends StatelessWidget {
  final int step;

  const PrimeScreen({required this.step, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> primes = findPrimes(3, 32767, step);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Números Primos'),
        backgroundColor: const Color.fromARGB(255, 243, 131, 181),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Result5Screen(step: step, primes: primes),
              ),
            );
          },
          child: const Text('Ver Resultados'),
        ),
      ),
    );
  }
}
