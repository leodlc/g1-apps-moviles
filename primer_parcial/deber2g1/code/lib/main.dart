import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logical/crud_usuario.dart';
import 'logical/login_usuario.dart';
import 'ui/formulario_login.dart';
import 'ui/admin/lista_usuarios.dart';
import 'ui/formulario.dart'; // Formulario de creación de usuario
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        initialRoute: '/login', // Ruta inicial
        routes: {
          '/login': (context) => const UserLoginForm(), // Formulario de login
          '/register': (context) =>
              const UserCreationForm(), // Formulario de registro
          '/users': (context) =>
              const ListaUsuarios(), // Lista de usuarios (pantalla de admin)
        },
      ),
    );
  }
}
