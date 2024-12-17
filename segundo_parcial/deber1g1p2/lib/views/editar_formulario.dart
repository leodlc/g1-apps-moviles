import 'package:flutter/material.dart';
import '../controllers/mis_creaciones_controller.dart';
import '../models/datos_model.dart';

class EditarFormulario extends StatefulWidget {
  final String tipo; // Puede ser 'personajes', 'comics', 'peliculas'
  final Datos datos; // Datos existentes para pre-cargar el formulario
  final String id; // ID del elemento a actualizar

  const EditarFormulario({
    Key? key,
    required this.tipo,
    required this.datos,
    required this.id,
  }) : super(key: key);

  @override
  State<EditarFormulario> createState() => _EditarFormularioState();
}

class _EditarFormularioState extends State<EditarFormulario> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _imagenController;
  late TextEditingController _infoController;

  final MisCreacionesController _controller = MisCreacionesController();

  @override
  void initState() {
    super.initState();

    // Inicializar los controladores con los datos existentes
    _nombreController = TextEditingController(text: widget.datos.nombre);
    _imagenController = TextEditingController(text: widget.datos.imagen);
    _infoController =
        TextEditingController(text: widget.datos.infoAdicional ?? '');
  }

  @override
  void dispose() {
    // Limpiar los controladores
    _nombreController.dispose();
    _imagenController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  void _actualizar() async {
    if (_formKey.currentState!.validate()) {
      final datosActualizados = Datos(
        nombre: _nombreController.text,
        imagen: _imagenController.text,
        infoAdicional: _infoController.text,
      );

      try {
        // Llamar al método actualizar del controlador
        await _controller.actualizarPelicula(widget.id, datosActualizados);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actualización exitosa')),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151313), // Fondo negro personalizado
      appBar: AppBar(
        backgroundColor: const Color(0xFF151313),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF852221)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'EDITAR ${widget.tipo.toUpperCase()}',
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
                    backgroundColor: const Color(0xFF852221),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _actualizar,
                  child: const Text(
                    'Actualizar',
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
