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
    final accentColor = Colors.grey.shade800;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categorización por Edad',
          style: TextStyle(
            color: accentColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingrese la edad para determinar la categoría:',
              style: TextStyle(
                fontSize: 16,
                color: accentColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // TextField con el ícono de "edad" dentro
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Edad',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: accentColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accentColor),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _calculateCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Calcular Categoría',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),

            if (_message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

