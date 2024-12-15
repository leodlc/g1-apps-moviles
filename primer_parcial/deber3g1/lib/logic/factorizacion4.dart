class Factorizacion4 {
  List<Map<String, int>> factorizar(int n) {
    List<Map<String, int>> resultado = [];
    int factor = 2;

    while (n > 1) {
      int potencia = 0;
      while (n % factor == 0) {
        potencia++;
        n ~/= factor;
      }
      if (potencia > 0) {
        resultado.add({'factor': factor, 'potencia': potencia});
      }
      factor++;
    }

    return resultado;
  }
}
