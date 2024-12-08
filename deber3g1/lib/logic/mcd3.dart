class mcd3 {
  List<Map<String, int>> mcd(int n1, int n2) {
    List<Map<String, int>> resultado = [];

    while (n1 != n2) {
      if (n1 > n2)
        n1 = n1 - n2;
      else
        n2 = n2 - n1;
    }
    resultado.add({'MCD': n1});
    return resultado;
  }
}