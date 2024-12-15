import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/ascii1_screen.dart';
import 'screens/factorial2_screen.dart';
import 'screens/mcd3_screen.dart';
import 'screens/factorizacion4_screen.dart';
import 'screens/primo_screen.dart';
import 'screens/info_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  // Lista de ejercicios con íconos de Font Awesome
  final List<Exercise> exers = [
    Exercise(
        name: 'ASCII',
        icon: FontAwesomeIcons.code,
        color: Colors.blue,
        route: const ASCII1Screen()),
    Exercise(
        name: 'Factorial',
        icon: FontAwesomeIcons.calculator,
        color: Colors.purple,
        route: const Factorial2Screen()),
    Exercise(
        name: 'MCD',
        icon: FontAwesomeIcons.divide,
        color: Colors.orange,
        route: const MCD3Screen()),
    Exercise(
        name: 'Factorización',
        icon: FontAwesomeIcons.sitemap,
        color: Colors.yellow,
        route: const Factorizacion4Screen()),
    Exercise(
        name: 'Primo',
        icon: FontAwesomeIcons.sortNumericUp,
        color: Colors.green,
        route: const PrimeScreen(step: 5)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarea 3'),
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    FontAwesomeIcons.clipboardList,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menú Principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.infoCircle, color: Colors.blue),
              title: const Text('Información'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: exers.length,
        itemBuilder: (context, index) {
          final exer = exers[index];

          // Comprobamos si es el último elemento
          final isLastItem = index == exers.length - 1;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => exer.route),
              );
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [exer.color.withOpacity(0.7), exer.color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: isLastItem
                      ? MainAxisAlignment.center // Centrado solo para el último elemento
                      : MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      exer.icon,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      exer.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Exercise {
  final String name;
  final IconData icon;
  final Color color;
  final Widget route;

  Exercise({
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
  });
}
