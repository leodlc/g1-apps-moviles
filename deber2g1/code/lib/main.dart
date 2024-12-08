import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa Provider
import 'logical/crud_usuario.dart'; // Asegúrate de usar el controlador correcto
import 'logical/login_usuario.dart'; // Importa UserLoginController
import 'ui/formulario_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/admin/lista_usuarios.dart';

void main() async {
  // Cargar el archivo .env
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserCrudController()),
        ChangeNotifierProvider(create: (_) => UserLoginController()),
      ],
      child: MaterialApp(
        title: 'Login',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const UserLoginForm(),
        //home: const ListaUsuarios(),
      ),
    );
  }
}
