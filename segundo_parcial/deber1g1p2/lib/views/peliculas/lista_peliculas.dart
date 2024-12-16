import 'package:flutter/material.dart';
import '/controllers/peliculas_controller.dart';
import '/models/peliculas_model.dart';
import 'info_pelicula.dart';

class ListaPeliculas extends StatelessWidget {
  const ListaPeliculas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PELÍCULAS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF151313),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF852221),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<PeliculasModel>>(
        future: PeliculasController().obtenerPeliculas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron películas.'));
          } else {
            final peliculas = snapshot.data!;
            return Column(
              children: [
                // Botón central superior
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Acción al presionar el botón
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF852221),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Cuadrícula de películas
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dos columnas
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 1,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: peliculas.length,
                    itemBuilder: (context, index) {
                      final pelicula = peliculas[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InfoPelicula(pelicula: pelicula),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xFF1E1C1C),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                child: Image.network(
                                  pelicula.coverUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  pelicula.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Fecha de lanzamiento
                              Text(
                                pelicula.releaseDate,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      backgroundColor: const Color(0xFF151313),
    );
  }
}
