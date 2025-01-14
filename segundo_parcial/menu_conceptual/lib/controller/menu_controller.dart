import 'package:flutter/material.dart';
import '../model/menu_option_model.dart';
import '../view/main_screen.dart';
import '../view/map_screen.dart';

class AppMenuController {
  List<MenuOption> getMenuOptions(BuildContext context) {
    return [
      MenuOption(
        title: 'Pagos de servicios básicos',
        icon: Icons.payment,
        onTap: () {
          // Lógica para pagos de servicios básicos
        },
      ),
      MenuOption(
        title: 'Empresa eléctrica',
        icon: Icons.lightbulb,
        onTap: () {
          // Lógica para empresa eléctrica
        },
      ),
      MenuOption(
        title: 'CNT',
        icon: Icons.phone,
        onTap: () {
          // Lógica para CNT
        },
      ),
      MenuOption(
        title: 'Consultar APIs',
        icon: Icons.api,
        onTap: () {
          // Lógica para consumir APIs y mostrar en otra pantalla
        },
      ),
      MenuOption(
        title: 'Ubicación ESPE',
        icon: Icons.location_on,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapScreen()),
          );
        },
      ),
    ];
  }
}
