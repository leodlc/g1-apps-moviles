import 'package:flutter/material.dart';
import '../controller/menu_controller.dart';
import '../controller/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/menu_option_model.dart';
import '../view/map_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserController userController = UserController();
  final AppMenuController appMenuController = AppMenuController(); // USO DEL MENU CONTROLLER CORRECTO

  @override
  Widget build(BuildContext context) {
    final user = userController.getUserData();
    final menuOptions = appMenuController.getMenuOptions(context); // Pasamos el context aquí

    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido a la app")),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.name),
              accountEmail: Text(user.username),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(user.profileImage),
              ),
            ),
            ...menuOptions.map((option) {
              return ListTile(
                leading: Icon(option.icon),
                title: Text(option.title),
                onTap: () {
                  option.onTap();
                  Navigator.pop(context); // Cerrar el menú lateral
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: Center(child: Text("Pantalla principal")),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Ubicación',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Llamar a la función 'launchURL' desde la instancia 'appMenuController'
            appMenuController.launchURL('https://maps.app.goo.gl/KCseY3fRXznkNapPA');
          }
        },
      ),
    );
  }
}
