import 'package:flutter/material.dart';
import 'package:menu_conceptual/view/home_screen.dart';
import 'package:menu_conceptual/view/map_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [HomeScreen(), MapScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banca Móvil'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nombre Apellido'),
              accountEmail: Text('@nombreUsuario'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpg'), // Imagen local
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Info Personal'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Ubicación ESPE'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
