import 'package:flutter/material.dart';
import '../../models/datos_model.dart';
import '../../controllers/mis_creaciones_controller.dart';
import '../editar_formulario.dart';

class InfoCreacionPersonaje extends StatelessWidget {
  final Datos personaje;

  const InfoCreacionPersonaje({Key? key, required this.personaje})
      : super(key: key);

  void _editarPersonaje(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarFormulario(
          tipo: 'personajes',
          datos: personaje, // Datos actuales del personaje
          id: personaje.id, // ID del elemento
        ),
      ),
    );
  }

  Future<void> _eliminarPersonaje(BuildContext context) async {
    final controller = MisCreacionesController();
    try {
      await controller
          .eliminarPersonaje(personaje.id); // Llamada al método eliminar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Personaje eliminado correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF151313),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF852221)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'INFORMACIÓN SOBRE: PERSONAJE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF151313),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Nombre del personaje
            Text(
              personaje.nombre.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Imagen del personaje
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                personaje.imagen,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 150,
                    color: Colors.white70,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Información adicional
            const Text(
              'INFORMACIÓN ADICIONAL:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              personaje.infoAdicional.isNotEmpty
                  ? personaje.infoAdicional
                  : 'No hay información adicional.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Botones de editar y eliminar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _editarPersonaje(context),
                  icon: const Icon(Icons.edit, color: Color(0xFF852221)),
                  iconSize: 40,
                ),
                const SizedBox(width: 50),
                IconButton(
                  onPressed: () => _eliminarPersonaje(context),
                  icon: const Icon(Icons.delete, color: Color(0xFF852221)),
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
