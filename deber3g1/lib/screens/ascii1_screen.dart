import 'package:flutter/material.dart';
import 'result1_screen.dart';

class ASCII1Screen extends StatefulWidget {
  const ASCII1Screen({super.key});

  @override
  _ASCII1ScreenState createState() => _ASCII1ScreenState();
}

class _ASCII1ScreenState extends State<ASCII1Screen> {
  final TextEditingController _controllerInput = TextEditingController();

  void _mostrarResultados() {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const Result1Screen()//(agregas aqui los parametros que necesites),
        //ej: Result2Screen(numero: numero, factorial: factorial),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caracter ASCII - Ejercicio 1')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controllerInput,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa un dato',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _mostrarResultados,
              child: const Text('Valor ASCII'),
            ),
          ],
        ),
      ),
    );
  }
}
