import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  double _pricePerShirt = 0;
  String _result = '';
  String _ageMessage = '';
  String _quantityMessage = '';

  @override
  void initState() {
    super.initState();
    _ageController.addListener(_validateAge);
    _quantityController.addListener(_validateQuantity);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _validateAge() {
    final String input = _ageController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _ageMessage = 'Por favor, ingresa una edad.';
        _pricePerShirt = 0;
      });
      return;
    }

    final int? age = int.tryParse(input);
    if (age == null || age < 0) {
      setState(() {
        _ageMessage = 'Por favor, ingresa un número válido para la edad.';
        _pricePerShirt = 0;
      });
      return;
    }

    setState(() {
      _ageMessage = '';
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
      } else {
        _pricePerShirt = 17.99;
      }
    });
  }

  void _validateQuantity() {
    final String input = _quantityController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _quantityMessage = 'Por favor, ingresa la cantidad de camisas.';
      });
      return;
    }

    final int? quantity = int.tryParse(input);
    if (quantity == null || quantity <= 0) {
      setState(() {
        _quantityMessage =
        'Por favor, ingresa un número válido y positivo para la cantidad.';
      });
      return;
    }

    setState(() {
      _quantityMessage = '';
    });
  }

  void _calculateTotal() {
    final String quantityInput = _quantityController.text.trim();

    if (_ageMessage.isNotEmpty || _quantityMessage.isNotEmpty) {
      setState(() {
        _result = 'Por favor, corrige los errores antes de continuar.';
      });
      return;
    }

    final int? quantity = int.tryParse(quantityInput);
    if (quantity == null || quantity <= 0 || _pricePerShirt == 0) {
      setState(() {
        _result = 'Error en los datos ingresados.';
      });
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

    double total = _pricePerShirt * quantity * (1 - discount);
    setState(() {
      _result =
      'Cantidad: $quantity camisas\nPrecio Unitario: \$${_pricePerShirt.toStringAsFixed(2)}\nDescuento: ${(discount * 100).toStringAsFixed(0)}%\nTotal: \$${total.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.grey.shade800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Camisas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingrese la edad para determinar el precio de la camiseta:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Edad',
                prefixIcon: Icon(Icons.person_outline, color: accentColor),
                border: const OutlineInputBorder(),
                errorText: _ageMessage.isNotEmpty ? _ageMessage : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingrese la cantidad de camisas que desea comprar:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cantidad de camisas',
                prefixIcon: Icon(Icons.add_shopping_cart, color: accentColor),
                border: const OutlineInputBorder(),
                errorText:
                _quantityMessage.isNotEmpty ? _quantityMessage : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateTotal,
              child: const Text('Calcular Total'),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Text(
                _result,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
