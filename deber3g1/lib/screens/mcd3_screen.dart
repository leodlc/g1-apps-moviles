import 'package:flutter/material.dart';
import '../logic/mcd3.dart';
import 'result3_screen.dart';

class mcd3Screen extends StatefulWidget {
  const mcd3Screen({super.key});

  @override
  _mcd3ScreenState createState() => _mcd3ScreenState();
}

class _mcd3ScreenState extends State<mcd3Screen> {
  final TextEditingController _controllerNumero1 = TextEditingController();
  final TextEditingController _controllerNumero2 = TextEditingController();

  void _mostrarResultados() {
    final numeroTexto1 = _controllerNumero1.text.trim();
    final numeroTexto2 = _controllerNumero2.text.trim();

    if (numeroTexto1.isEmpty || int.tryParse(numeroTexto1) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un número válido')),
      );
      return;
    }

    if (numeroTexto2.isEmpty || int.tryParse(numeroTexto2) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un número válido')),
      );
      return;
    }

    final numero1 = int.parse(numeroTexto1);
    final numero2 = int.parse(numeroTexto2);
    final calculoMCD = mcd3().mcd(numero1, numero2);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Result3Screen(numero1: numero1, calculoMCD: calculoMCD),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('M.C.D. de un Número - Ejercicio 3')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controllerNumero1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa un número entero',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _mostrarResultados,
              child: const Text('Calculo MCD'),
            ),
          ],
        ),
      ),
    );
  }
}
