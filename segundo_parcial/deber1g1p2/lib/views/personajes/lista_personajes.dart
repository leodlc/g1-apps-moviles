import 'package:flutter/material.dart';
import '/../controllers/personajes_controller.dart';
import '../personajes/info_personaje.dart';
import '/../models/personajes_model.dart';

class ListaPersonajes extends StatelessWidget {
  const ListaPersonajes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = PersonajesController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PERSONAJES',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF151313), // Fondo negro personalizado
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF852221), // Color personalizado para el botón regresar
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Personaje>>(
        future: controller.fetchPersonajes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje si ocurre un error
            return const Center(
              child: Text(
                'Error al cargar los personajes.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.hasData) {
            // Si se obtienen los datos, genera la lista de personajes
            final personajes = snapshot.data!;
            return ListView.builder(
              itemCount: personajes.length,
              itemBuilder: (context, index) {
                final personaje = personajes[index];
                return Card(
                  color: const Color(0xFF252525),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        personaje.imageUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      personaje.name,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      personaje.description.length > 30
                          ? '${personaje.description.substring(0, 30)}...'
                          : personaje.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    onTap: () {
                      // Navega a la pantalla de detalles del personaje
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InfoPersonajes(personaje: personaje),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            // Muestra un mensaje si no se encuentran personajes
            return const Center(
              child: Text(
                'No se encontraron personajes.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
      backgroundColor: const Color(0xFF151313), // Fondo negro personalizado
    );
  }
}
