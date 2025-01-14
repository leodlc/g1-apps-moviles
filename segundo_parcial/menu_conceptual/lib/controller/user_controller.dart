import '../model/user_model.dart';

class UserController {
  User getUserData() {
    return User(
      name: 'Josué Pérez',
      username: 'joseperez',
      profileImage: 'assets/images/profile.jpg', // Puedes cambiar la ruta de la imagen
    );
  }
}
