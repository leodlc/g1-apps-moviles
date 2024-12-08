class ASCIIConverter {
  /// Retorna el código ASCII de un carácter válido.
  /// Si la entrada no es válida, lanza una excepción.
  static int getASCIIValue(String input) {
    if (input.isEmpty || input.length != 1) {
      throw ArgumentError('Debes ingresar un solo carácter.');
    }
    return input.codeUnitAt(0);
  }
}