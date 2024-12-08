import 'package:flutter/material.dart';
import 'screens/ascii1_screen.dart';
import 'screens/factorial2_screen.dart';
import 'screens/mcd3_screen.dart';
import 'screens/factorizacion4_screen.dart';
import 'screens/primo_screen.dart';
import 'screens/info_Screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  // List of exercises with a color for each icon
  final List<Exercise> exers = [
    Exercise(
        name: 'Ejercicio 1',
        icon: Icons.electric_bolt,
        color: const Color.fromARGB(255, 9, 118, 219),
        route: ASCII1Screen()),
    Exercise(
        name: 'Ejercicio 2',
        icon:  FontAwesomeIcons.times,
        color: const Color.fromARGB(255, 134, 70, 132),
        route: Factorial2Screen()),
    Exercise(
        name: 'Ejercicio 3',
        icon:  FontAwesomeIcons.divide,
        color: Colors.orange,
        route: mcd3Screen()),
    Exercise(
        name: 'Ejercicio 4',
        icon:  FontAwesomeIcons.equals,
        color: Colors.yellow,
        route: Factorizacion4Screen()),
    Exercise(
        name: 'Ejercicio 5',
        icon: Icons.plus_one,
        color: Colors.yellow,
        route: PrimeScreen(step: 5)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarea 3'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Info'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoScreen()),
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => exer.route),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    exer.icon,
                    size: 50,
                    color:
                    exer.color,
                  ),
                  const SizedBox(height: 10),
                  Text(exer.name, style: const TextStyle(fontSize: 16)),
                ],
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

  Exercise(
      {required this.name,
        required this.icon,
        required this.color,
        required this.route});
}
