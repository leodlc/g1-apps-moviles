import 'package:flutter/material.dart';
import '../logic/mcd3.dart';
import 'result3_screen.dart';

class MCD3Screen extends StatefulWidget {
  const MCD3Screen({super.key});

  @override
  _MCD3ScreenState createState() => _MCD3ScreenState();
}

class _MCD3ScreenState extends State<MCD3Screen> {
  final TextEditingController _controllerNumero1 = TextEditingController();
  final TextEditingController _controllerNumero2 = TextEditingController();

  void _mostrarResultados() {
    final numeroTexto1 = _controllerNumero1.text.trim();
    final numeroTexto2 = _controllerNumero2.text.trim();

    // Validación de entradas
    if (numeroTexto1.isEmpty || int.tryParse(numeroTexto1) == null) {
      _mostrarError('Por favor, ingresa un número válido en el campo 1');
      return;
    }

    if (numeroTexto2.isEmpty || int.tryParse(numeroTexto2) == null) {
      _mostrarError('Por favor, ingresa un número válido en el campo 2');
      return;
    }

    final numero1 = int.parse(numeroTexto1);
    final numero2 = int.parse(numeroTexto2);

    final resultado = mcd3().mcd(numero1, numero2);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Result3Screen(numero1: numero1, numero2: numero2, resultado: resultado),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo del MCD - Ejercicio 3'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controllerNumero1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa el primer número entero',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controllerNumero2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa el segundo número entero',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _mostrarResultados,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Calcular MCD',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
