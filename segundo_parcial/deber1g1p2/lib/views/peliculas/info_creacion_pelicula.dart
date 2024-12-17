import 'package:flutter/material.dart';
import '../../models/datos_model.dart';
import '../../controllers/mis_creaciones_controller.dart';
/* import '../creacion_formulario.dart'; */
import '../editar_formulario.dart';

class InfoCreacionPelicula extends StatelessWidget {
  final Datos pelicula;

  const InfoCreacionPelicula({Key? key, required this.pelicula})
      : super(key: key);

  void _editarPelicula(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarFormulario(
          tipo: 'peliculas',
          datos: pelicula, // Datos actuales
          id: pelicula.id, // ID del elemento
        ),
      ),
    );
  }

  Future<void> _eliminarPelicula(BuildContext context) async {
    final controller = MisCreacionesController();
    try {
      await controller.eliminarPelicula(pelicula.id); // Ahora se puede usar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada correctamente')),
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
          'INFORMACIÓN SOBRE: PELÍCULA',
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
            Text(
              pelicula.nombre.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                pelicula.imagen,
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
              pelicula.infoAdicional.isNotEmpty
                  ? pelicula.infoAdicional
                  : 'No hay información adicional.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _editarPelicula(context),
                  icon: const Icon(Icons.edit, color: Color(0xFF852221)),
                  iconSize: 40,
                ),
                const SizedBox(width: 50),
                IconButton(
                  onPressed: () => _eliminarPelicula(context),
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
