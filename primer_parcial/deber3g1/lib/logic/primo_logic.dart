List<int> findPrimes(int start, int end, int step) {
  List<int> primes = [];

  for (int numero = start; numero <= end; numero += step) {
    bool isPrime = true;

    for (int x = 2; x < numero; x++) {
      if (numero % x == 0) {
        isPrime = false;
        break;
      }
    }

    if (isPrime) {
      primes.add(numero);
    }
  }

  return primes;
}