import 'package:flutter/material.dart';
import 'views/menu.dart';
import 'views/personajes/lista_personajes.dart';
import 'views/comics/lista_comics.dart';
import 'views/peliculas/lista_peliculas.dart';

void main() {
  runApp(const MarvelApp());
}

class MarvelApp extends StatelessWidget {
  const MarvelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marvel API',
      initialRoute: '/',
      routes: {
        '/': (context) => const Menu(),
        '/personajes': (context) => const ListaPersonajes(),
        '/comics': (context) => const ListaComics(),
        '/peliculas': (context) => const ListaPeliculas(),
      },
    );
  }
}
