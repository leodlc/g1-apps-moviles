class UserCreationController {
  // Método para validar datos del formulario
  bool validateUserData(String name, String email, String password) {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return false;
    }
    if (password.length < 6) {
      return false;
    }
    return true;
  }

  // Método para simular el envío de datos al backend
  Future<bool> submitUserData(Map<String, String> userData) async {
    // Aquí podrías integrar la llamada a una API REST en el futuro
    print("Datos enviados al backend: $userData");
    await Future.delayed(Duration(seconds: 2)); // Simula un retraso de red
    return true; // Retorna true para indicar éxito
  }
}
