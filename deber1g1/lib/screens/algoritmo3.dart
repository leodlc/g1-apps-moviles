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
      appBar: AppBar(title: Text('Verificar Terna Pitagórica')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _aController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ingrese el valor de a'),
            ),
            TextField(
              controller: _bController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ingrese el valor de b'),
            ),
            TextField(
              controller: _cController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ingrese el valor de c'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarTernaPitagorica,
              child: Text('Verificar'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
