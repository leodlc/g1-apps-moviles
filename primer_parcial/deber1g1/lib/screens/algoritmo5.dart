import 'package:flutter/material.dart';

class FifthScreen extends StatefulWidget {
  const FifthScreen({super.key});

  @override
  _FifthScreenState createState() => _FifthScreenState();
}

class _FifthScreenState extends State<FifthScreen> {
  final _sueldoBaseController = TextEditingController();
  final _ventasController = TextEditingController();
  String _resultado = "";

  // Función para calcular el sueldo total
  void _calcularSueldo() {
    double? sueldoBase = double.tryParse(_sueldoBaseController.text);
    double? ventas = double.tryParse(_ventasController.text);

    if (sueldoBase == null || ventas == null || ventas < 0) {
      setState(() {
        _resultado = "Datos inválidos. Verifique los valores ingresados.";
      });
      return;
    }

    double comision;
    if (ventas < 4000000) {
      comision = 0;
    } else if (ventas >= 4000000 && ventas < 10000000) {
      comision = ventas * 0.03;
    } else {
      comision = ventas * 0.07;
    }

    double sueldoTotal = sueldoBase + comision;
    setState(() {
      _resultado = "El sueldo mensual del vendedor es: \$${sueldoTotal.toStringAsFixed(2)}";
    });
  }

  @override
  void dispose() {
    _sueldoBaseController.dispose();
    _ventasController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Sueldo Mensual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _sueldoBaseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sueldo Base',
                prefixIcon: Icon(Icons.monetization_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _ventasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ventas del Mes',
                prefixIcon: Icon(Icons.shopping_cart),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _calcularSueldo,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular Sueldo Mensual',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 95, 95, 95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
