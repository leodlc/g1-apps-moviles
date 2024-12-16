import 'package:translator/translator.dart';

class TraduccionController {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> traducirTexto(String texto, String idiomaDestino) async {
    try {
      final translation = await _translator.translate(texto, to: idiomaDestino);
      return translation.text;
    } catch (e) {
      throw Exception('Error al traducir: $e');
    }
  }
}
