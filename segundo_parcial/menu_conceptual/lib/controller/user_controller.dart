import 'package:menu_conceptual/model/user_model.dart';

class UserController {
  User getUser() {
    return User(
      name: 'Josué',
      username: '@josue123',
      photoUrl: 'assets/user.jpg',
    );
  }
}
