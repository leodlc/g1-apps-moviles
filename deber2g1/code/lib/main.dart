import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa Provider
import 'logical/crud_usuario.dart'; // Asegúrate de usar el controlador correcto
import 'ui/admin/lista_usuarios.dart';
import 'ui/formulario_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Cargar el archivo .env
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserCrudController(),
      child: MaterialApp(
        title: 'Login',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const UserLoginForm(),
        //home: const ListaUsuarios(),
      ),
    );
  }
}
