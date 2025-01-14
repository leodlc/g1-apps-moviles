import 'package:menu_conceptual/model/menu_option_model.dart';

class MenuController {
  List<MenuOption> getMenuOptions() {
    return [
      MenuOption(title: 'Pagos', icon: 'Icons.payment', onTap: () {}),
      MenuOption(title: 'Empresa Eléctrica', icon: 'Icons.lightbulb', onTap: () {}),
      MenuOption(title: 'CNT', icon: 'Icons.phone', onTap: () {}),
    ];
  }
}
