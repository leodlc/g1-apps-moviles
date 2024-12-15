import 'package:flutter/material.dart';
import '../controllers/mis_creaciones_controller.dart';
import '../models/datos_model.dart';

class CreacionFormulario extends StatefulWidget {
  final String tipo; // Puede ser 'personajes', 'comics', 'peliculas'
  const CreacionFormulario({Key? key, required this.tipo}) : super(key: key);

  @override
  State<CreacionFormulario> createState() => _CreacionFormularioState();
}

class _CreacionFormularioState extends State<CreacionFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _imagenController = TextEditingController();
  final _infoController = TextEditingController();

  final MisCreacionesController _controller = MisCreacionesController();

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      final nuevoDato = Datos(
        nombre: _nombreController.text,
        imagen: _imagenController.text,
        infoAdicional: _infoController.text,
      );

      try {
        // Envía solo el objeto 'nuevoDato' al controlador
        await _controller.crearDato(widget.tipo, nuevoDato);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Creación exitosa')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151313), // Fondo negro personalizado
      appBar: AppBar(
        backgroundColor: const Color(0xFF151313), // Fondo negro del AppBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF852221)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CREAR {${widget.tipo.toUpperCase()}}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                controller: _nombreController,
                label: 'Nombre',
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _imagenController,
                label: 'Imagen (URL)',
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _infoController,
                label: 'Info adicional',
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF852221), // Botón rojo personalizado
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Bordes redondeados
                    ),
                  ),
                  onPressed: _guardar,
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para reutilizar estilos de los TextFormField
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF852221), width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF852221), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF852221), width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
    );
  }
}
