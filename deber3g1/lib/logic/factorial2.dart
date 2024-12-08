class FactorialCalculator {
  /// Calcula el factorial de un número entero no negativo.
  /// Lanza una excepción si el número es negativo.
  static int calculateFactorial(int number) {
    if (number < 0) {
      throw ArgumentError('El número debe ser no negativo.');
    }
    return number == 0 ? 1 : number * calculateFactorial(number - 1);
  }
}
