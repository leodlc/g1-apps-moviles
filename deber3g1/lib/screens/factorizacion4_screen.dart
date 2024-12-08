import 'package:flutter/material.dart';
import '../logic/factorizacion4.dart';
import 'result4_screen.dart';
import 'primo_screen.dart'; 

class Factorizacion4Screen extends StatefulWidget {
  const Factorizacion4Screen({super.key});

  @override
  _Factorizacion4ScreenState createState() => _Factorizacion4ScreenState();
}

class _Factorizacion4ScreenState extends State<Factorizacion4Screen> {
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
    final factorizacion = Factorizacion4().factorizar(numero);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Result4Screen(numero: numero, factorizacion: factorizacion),
      ),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Factorización de un Número - Ejercicio 4')),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla PrimeScreen con un valor para 'step'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrimeScreen(step: 1), 
                  ),
                );
              },
              child: const Text('Ver Números Primos'),
            ),
          ],
        ),
      ),
    );
  }
}