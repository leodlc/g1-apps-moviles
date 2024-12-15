import 'package:flutter/material.dart';
import '../../logical/crud_usuario.dart';

class AdminEditarUsuario extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const AdminEditarUsuario({super.key, required this.usuario});

  @override
  State<AdminEditarUsuario> createState() => _AdminEditarUsuarioState();
}

class _AdminEditarUsuarioState extends State<AdminEditarUsuario> {
  final _formKey = GlobalKey<FormState>();
  final UserCrudController _userController = UserCrudController();
  late Map<String, dynamic> _editedData;

  @override
  void initState() {
    super.initState();
    _editedData = Map.from(widget.usuario); // Inicializar los datos del usuario
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _userController.updateUser(
          _editedData['id'].toString(),
          _editedData,
        );
        Navigator.of(context)
            .pop(true); // Retornar `true` si se guardaron los cambios
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cambios: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Usuario'),
      titleTextStyle: const TextStyle(color: Colors.white), // Azul
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _editedData['username'],
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.blue), // Azul
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue, // Azul al enfocar
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) => _editedData['username'] = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre de usuario es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _editedData['email'],
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) => _editedData['email'] = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El email es requerido';
                  }
                  return null;
                },
              ),
              // Agrega más campos si es necesario
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Cancelar
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, // Texto azul
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarCambios, // Guardar cambios
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Fondo azul
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            'Guardar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
