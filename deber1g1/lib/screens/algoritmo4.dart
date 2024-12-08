import 'package:flutter/material.dart';

class FourthScreen extends StatefulWidget {
  const FourthScreen({super.key});

  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  final TextEditingController _controller = TextEditingController();
  String _resultado = '';

  // Función para calcular el costo basado en el consumo sin IVA
  double calcularSubtotal(int consumo) {
    if (consumo <= 50) {
      // Primer tramo (120)
      return consumo * 30;
    } else if (consumo <= 100) {
      int consumoExceso = consumo - 50;
      return (50 * 30) + (consumoExceso * 35);
    } else {
      int consumoExceso = consumo - 100;
      return (50 * 30) + (50 * 35) + (consumoExceso * 42);
    }
  }

  // Función para manejar el cálculo del total con IVA y actualizar la UI
  void _calcular() {
    int? consumo = int.tryParse(_controller.text);

    // Validación de datos
    if (consumo == null || consumo < 0) {
      setState(() {
        _resultado = 'Por favor, ingrese un consumo válido (número positivo).';
      });
      return;
    }

    double subtotal = calcularSubtotal(consumo);
    double iva = subtotal * 0.15; // 15% de IVA
    double totalConIva = subtotal + iva;

    setState(() {
      _resultado = '''
Subtotal sin IVA: \$${subtotal.toStringAsFixed(2)}
IVA (15%): \$${iva.toStringAsFixed(2)}
Total a pagar: \$${totalConIva.toStringAsFixed(2)}
      ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 4 - Costo de Electricidad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ingrese el consumo de electricidad en KWH:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Consumo en KWH',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text('Calcular Costo'),
            ),
            const SizedBox(height: 20),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
