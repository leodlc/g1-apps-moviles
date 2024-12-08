class UserLoginController {
  //Validación de campos de entrada
  bool validadorCamposLogin(String userLogin, String passwordLogin ){
    if(userLogin.isEmpty || passwordLogin.isEmpty ){
      return false;
    }
    if (passwordLogin.length < 6) {
      return false;
    }
    return true;
  }
// Método para simular el envío de datos al backend
  Future<bool> submitUserLoginData(Map<String, String> userData) async {
  // Aquí podrías integrar la llamada a una API REST en el futuro
  print("Datos enviados al backend: $userData");
  await Future.delayed(const Duration(seconds: 2)); // Simula un retraso de red
  return true; // Retorna true para indicar éxito
  }
}