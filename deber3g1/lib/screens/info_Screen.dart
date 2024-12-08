import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos colores personalizados para un tema minimalista
    final accentColor = Colors.grey.shade800;
    final backgroundColor = Colors.grey.shade50;
    final cardColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 2,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsVFSqbF7n79uSZNX7yYJeBmBeL4HgeiKudA&s',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Desarrollo de Aplicaciones Móviles\nGrupo 1',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Integrantes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      'Daniel Armas',
                      'Leonardo De La Cadena',
                      'Josué Merino',
                      'Vanessa Zurita',
                    ]
                        .map((nombre) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
