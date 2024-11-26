import 'package:flutter/material.dart';
import '../logical/creacion_de_usuario.dart';
import 'formulario_login.dart';
import 'formulario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UserLoginForm(),
    );
  }
}
