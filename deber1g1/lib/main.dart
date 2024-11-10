import 'package:flutter/material.dart';
import 'screens/algoritmo1.dart';
import 'screens/algoritmo2.dart';
import 'screens/algoritmo3.dart';
import 'screens/algoritmo4.dart';
import 'screens/algoritmo5.dart';
import 'screens/algoritmo6.dart';
import 'screens/info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  final List<Exercise> exers = [
    Exercise(name: 'Ejercicio 1', icon: Icons.bed, route: OneScreen()),
    Exercise(name: 'Ejercicio 2', icon: Icons.kitchen, route: SecondScreen()),
    Exercise(name: 'Ejercicio 3', icon: Icons.chair, route: ThirdScreen()),
    Exercise(
        name: 'Ejercicio 4',
        icon: Icons.local_laundry_service,
        route: FourthScreen()),
    Exercise(name: 'Ejercicio 5', icon: Icons.bathtub, route: FifthScreen()),
    Exercise(name: 'Ejercicio 6', icon: Icons.tv, route: SixthScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios tarea 1'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
              leading: Icon(Icons.info),
              title: Text('Info'),
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
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas en el grid
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
                  Icon(exer.icon, size: 50),
                  SizedBox(height: 10),
                  Text(exer.name, style: TextStyle(fontSize: 16)),
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
  final Widget route;

  Exercise({required this.name, required this.icon, required this.route});
}
