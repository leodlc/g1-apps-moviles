import 'package:flutter/material.dart';

class OneScreen extends StatefulWidget {
  @override
  _OneScreenState createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen> {
  final TextEditingController _ageController = TextEditingController();
  String _message = '';

  void _calculateCategory() {
    setState(() {
      final String input = _ageController.text.trim();

      if (input.isEmpty) {
        _message = 'Ingresa una edad';
        return;
      }

      final int? age = int.tryParse(input);
      if (age == null || age < 0) {
        _message = 'Por favor, ingresa un número válido para la edad.';
        return;
      }

      if (age <= 10) {
        _message = 'NIÑO';
      } else if (age > 10 && age <= 14) {
        _message = 'PUBER';
      } else if (age > 14 && age <= 18) {
        _message = 'ADOLESCENTE';
      } else if (age > 18 && age <= 25) {
        _message = 'JOVEN';
      } else if (age > 25 && age <= 65) {
        _message = 'ADULTO';
      } else if (age > 65 && age <= 100) {
        _message = 'ANCIANO';
      } else if (age > 100) {
        _message = 'INMORTAL';
      } else {
        _message = 'Edad no válida.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorización por Edad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingrese la edad para determinar la categoría:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateCategory,
              child: Text('Calcular Categoría'),
            ),
            SizedBox(height: 20),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
