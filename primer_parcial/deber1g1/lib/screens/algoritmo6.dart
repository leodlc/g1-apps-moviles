import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para TextInputFormatter

class SixthScreen extends StatefulWidget {
  const SixthScreen({super.key});

  @override
  _SixthScreenState createState() => _SixthScreenState();
}

class _SixthScreenState extends State<SixthScreen> {
  final _paltosController = TextEditingController();
  final _limonesController = TextEditingController();
  final _chirimoyosController = TextEditingController();
  String _resultado = "";

  void _calcularTotal() {
    int cantidadPaltos = int.tryParse(_paltosController.text) ?? 0;
    int cantidadLimones = int.tryParse(_limonesController.text) ?? 0;
    int cantidadChirimoyos = int.tryParse(_chirimoyosController.text) ?? 0;

    // Precios unitarios
    double precioPalto = 1200;
    double precioLimon = 1000;
    double precioChirimoya = 980;

    // Calcular subtotal sin descuentos
    double totalPaltos = cantidadPaltos * precioPalto;
    double totalLimones = cantidadLimones * precioLimon;
    double totalChirimoyos = cantidadChirimoyos * precioChirimoya;

    // Aplicar descuentos por tipo de árbol
    if (cantidadPaltos >= 100 && cantidadPaltos <= 300) {
      totalPaltos *= 0.90; // 10% de descuento
    } else if (cantidadPaltos > 300) {
      totalPaltos *= 0.82; // 18% de descuento
    }

    if (cantidadLimones >= 100 && cantidadLimones <= 300) {
      totalLimones *= 0.875; // 12.5% de descuento
    } else if (cantidadLimones > 300) {
      totalLimones *= 0.80; // 20% de descuento
    }

    if (cantidadChirimoyos >= 100 && cantidadChirimoyos <= 300) {
      totalChirimoyos *= 0.855; // 14.5% de descuento
    } else if (cantidadChirimoyos > 300) {
      totalChirimoyos *= 0.81; // 19% de descuento
    }

    // Calcular total sin IVA
    double totalSinIVA = totalPaltos + totalLimones + totalChirimoyos;
    int cantidadTotalArboles = cantidadPaltos + cantidadLimones + cantidadChirimoyos;

    // Aplicar descuento adicional si hay más de 1000 árboles
    if (cantidadTotalArboles > 1000) {
      totalSinIVA *= 0.85; // 15% de descuento adicional
    }

    // Calcular total con IVA (12%)
    double totalConIVA = totalSinIVA * 1.12;

    setState(() {
      _resultado = "Total a pagar con IVA: \$${totalConIVA.toStringAsFixed(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tv Room - Cálculo de Árboles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _paltosController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Cantidad de Paltos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _limonesController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Cantidad de Limones',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _chirimoyosController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Cantidad de Chirimoyos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calcularTotal,
              child: const Text('Calcular Total'),
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
