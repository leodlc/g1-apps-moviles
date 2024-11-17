import 'package:flutter/material.dart';
import 'dart:math';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  double _pricePerShirt = 0;
  String _result = '';
  String _message = '';

  double _calculateCategory() {
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
        _pricePerShirt = 4.99;
      } else if (age > 10 && age <= 14) {
        _pricePerShirt = 7.99;
      } else if (age > 14 && age <= 18) {
        _pricePerShirt = 9.99;
      } else if (age > 18 && age <= 25) {
        _pricePerShirt = 14.99;
      } else if (age > 25 && age <= 65) {
        _pricePerShirt = 19.99;
      } else if (age > 65) {
        _pricePerShirt = 17.99;
      } else {
        _message = 'Edad no válida.';
      }
    });
    return _pricePerShirt;
  }

  void _calculateTotal() {
    setState(() {
      final String quantityInput = _quantityController.text.trim();

      if (quantityInput.isEmpty) {
        _result = 'Por favor, ingresa la cantidad de camisas.';
        return;
      }

      final int? quantity = int.tryParse(quantityInput);
      if (quantity == null || quantity <= 0) {
        _result = 'Por favor, ingresa un número válido y positivo para la cantidad.';
        return;
      }

      double price = _calculateCategory();
      if (price == 0) {
        _result = _message;
        return;
      }

      // Lógica de descuento según cantidad
      double discount = 0;
      if (quantity >= 4 && quantity <= 10) {
        discount = 0.10;
      } else if (quantity >= 11 && quantity <= 20) {
        discount = 0.15;
      } else if (quantity >= 21 && quantity <= 30) {
        discount = 0.20;
      } else if (quantity > 30) {
        discount = 0.50;
      }

      double total = price * quantity * (1 - discount);
      _result = 'Cantidad: $quantity camisas\nPrecio Unitario: \$${price.toStringAsFixed(2)}\nDescuento: ${(discount * 100).toStringAsFixed(0)}%\nTotal: \$${total.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo de Camisas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingrese la edad para determinar el precio de la camiseta:',
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
            Text(
              'Ingrese la cantidad de camisas que desea comprar:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cantidad de camisas',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateTotal,
              child: Text('Calcular Total'),
            ),
            SizedBox(height: 20),
            if (_result.isNotEmpty)
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
