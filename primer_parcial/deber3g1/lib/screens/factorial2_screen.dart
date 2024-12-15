import 'package:flutter/material.dart';
import '../logic/factorial2.dart';
import 'result2_screen.dart';

class Factorial2Screen extends StatefulWidget {
  const Factorial2Screen({super.key});

  @override
  _Factorial2ScreenState createState() => _Factorial2ScreenState();
}

class _Factorial2ScreenState extends State<Factorial2Screen> {
  final TextEditingController _controllerNumero = TextEditingController();

  void _mostrarResultados() {
    final numeroTexto = _controllerNumero.text.trim();
    if (numeroTexto.isEmpty || int.tryParse(numeroTexto) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un número válido')),
      );
      return;
    }

    final numero = int.parse(numeroTexto);
    try {
      final factorial = FactorialCalculator.calculateFactorial(numero);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Result2Screen(numero: numero, factorial: factorial),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Factorial de un Número - Ejercicio 2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controllerNumero,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa un número entero',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _mostrarResultados,
              child: const Text('Factorial'),
            ),
          ],
        ),
      ),
    );
  }
}
