import 'package:flutter/material.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  String _result = '';

  // Función para verificar si es una terna pitagórica
  void verificarTernaPitagorica() {
    // Convertimos los valores a enteros
    int a = int.tryParse(_aController.text) ?? 0;
    int b = int.tryParse(_bController.text) ?? 0;
    int c = int.tryParse(_cController.text) ?? 0;

    // Verificamos las condiciones de terna pitagórica
    if (a * a + b * b == c * c ||
        a * a + c * c == b * b ||
        b * b + c * c == a * a) {
      setState(() {
        _result = "Los números ($a, $b, $c) forman una terna pitagórica.";
      });
    } else {
      setState(() {
        _result = "Los números ($a, $b, $c) NO forman una terna pitagórica.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verificar Terna Pitagórica'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _aController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor de a',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor de b',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor de c',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: verificarTernaPitagorica,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Verificar',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
