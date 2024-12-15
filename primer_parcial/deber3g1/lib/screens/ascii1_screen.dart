import 'package:flutter/material.dart';
import '../logic/ascii1.dart';
import 'result1_screen.dart';

class ASCII1Screen extends StatefulWidget {
  const ASCII1Screen({super.key});

  @override
  _ASCII1ScreenState createState() => _ASCII1ScreenState();
}

class _ASCII1ScreenState extends State<ASCII1Screen> {
  final TextEditingController _controllerInput = TextEditingController();
  String? _error;

  void _mostrarResultados() {
    final input = _controllerInput.text.trim();
    try {
      final asciiValue = ASCIIConverter.getASCIIValue(input);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Result1Screen(character: input, asciiValue: asciiValue),
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caracter ASCII - Ejercicio 1'),
        backgroundColor: Colors.lightBlue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controllerInput,
              decoration: InputDecoration(
                labelText: 'Ingresa un carácter',
                border: const OutlineInputBorder(),
                errorText: _error,
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
