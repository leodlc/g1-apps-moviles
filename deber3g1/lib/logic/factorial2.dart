class FactorialCalculator {
  static BigInt calculateFactorial(int number) {
    if (number < 0) {
      throw ArgumentError('El número debe ser no negativo.');
    }

    BigInt factorial = BigInt.one;
    for (int i = 1; i <= number; i++) {
      factorial *= BigInt.from(i);
    }
    return factorial;
  }
}
