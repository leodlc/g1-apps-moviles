import 'package:flutter/material.dart';
import 'screens/factorizacion4_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      title: 'Factorización4 App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Factorizacion4Screen(), // Redirige a la pantalla de factorización
    );
  }
}
