import 'package:flutter/material.dart';
import 'dart:ui';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'API DE MARVEL GRUPO 1',
          style: TextStyle(
            color: Colors.white, // Texto en blanco
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF151313), // Fondo negro personalizado
        elevation: 0, // Sin sombra
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xFF151313), // Fondo negro personalizado
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuOption(
                  imagePath: 'assets/characters.jpg',
                  title: 'PERSONAJES',
                  onTap: () {
                    Navigator.pushNamed(context, '/personajes');
                  },
                ),
                MenuOption(
                  imagePath: 'assets/comic.jpg',
                  title: 'COMICS',
                  onTap: () {
                    Navigator.pushNamed(context, '/comics');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            MenuOption(
              imagePath: 'assets/movies.jpg',
              title: 'PELICULAS',
              onTap: () {
                Navigator.pushNamed(context, '/peliculas');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuOption extends StatefulWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const MenuOption({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  _MenuOptionState createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Imagen principal con posible efecto de blur
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                      ),
                      if (isTapped)
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: const Color(0xFF882424)
                                .withOpacity(0.1), // Rojo personalizado
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Texto centrado con sombra
              Center(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
