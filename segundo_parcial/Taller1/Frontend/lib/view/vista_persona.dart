import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/modelo_persona.dart';
import '../controller/controlador_persona.dart';

class VistaPersona extends StatefulWidget {
  const VistaPersona({super.key});

  @override
  _VistaPersonaState createState() => _VistaPersonaState();
}

class _VistaPersonaState extends State<VistaPersona> {
  // Color palette
  static final Color _primaryColor = Color(0xFF4A90E2);      
  static final Color _accentColor = Color(0xFF5DADE2);       
  static final Color _backgroundColor = Color(0xFFF4F6F7);   
  static final Color _textColor = Color(0xFF2C3E50);         
  static final Color _secondaryTextColor = Color(0xFF34495E); 

  List<Persona> _personas = [];
  final PersonaService personaService = PersonaService();

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  Future<void> _actualizarLista() async {
    try {
      List<Persona> personas = await personaService.obtenerPersonas();
      setState(() {
        _personas = personas;
      });
    } catch (e) {
      print("Error al cargar personas: $e");
    }
  }

  void _mostrarFormulario({Persona? persona}) {
    final nombreController = TextEditingController();
    final apellidoController = TextEditingController();
    final telefonoController = TextEditingController();

    if (persona != null) {
      nombreController.text = persona.nombre;
      apellidoController.text = persona.apellido;
      telefonoController.text = persona.telefono;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                persona == null 
                  ? FontAwesomeIcons.userPlus 
                  : FontAwesomeIcons.edit, 
                color: _primaryColor,
                size: 20, 
              ),
              const SizedBox(width: 10),
              Text(
                persona == null ? 'Agregar Persona' : 'Editar Persona',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: nombreController,
                  label: 'Nombre',
                  icon: FontAwesomeIcons.penAlt, 
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: apellidoController,
                  label: 'Apellido',
                  icon: FontAwesomeIcons.signature, 
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: telefonoController,
                  label: 'Teléfono',
                  icon: FontAwesomeIcons.mobileAlt, 
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final apellido = apellidoController.text.trim();
                final telefono = telefonoController.text.trim();

                if (nombre.isNotEmpty && apellido.isNotEmpty && telefono.isNotEmpty) {
                  try {
                    final nuevaPersona = Persona(
                      id: persona?.id ?? '',
                      nombre: nombre,
                      apellido: apellido,
                      telefono: telefono,
                    );
                    if (persona == null) {
                      await personaService.crearPersona(nuevaPersona);
                    } else {
                      await personaService.actualizarPersona(persona.id, nuevaPersona);
                    }
                    _actualizarLista();
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error al guardar persona: $e');
                  }
                }
              },
              icon: Icon(
                persona == null 
                  ? FontAwesomeIcons.check 
                  : FontAwesomeIcons.refresh, 
                size: 20, 
              ),
              label: Text(persona == null ? 'Agregar' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: _textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _primaryColor),
        prefixIcon: Icon(icon, color: _primaryColor, size: 20), 
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  void _eliminarPersona(String id) async {
    try {
      await personaService.eliminarPersona(id);
      _actualizarLista();
    } catch (e) {
      print("Error al eliminar persona: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('CRUD Personas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: _primaryColor,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: _personas.length,
          itemBuilder: (context, index) {
            final persona = _personas[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _accentColor,
                  child: Icon(
                    FontAwesomeIcons.userAlt,
                    color: Colors.white,
                    size: 20, // Tamaño más pequeño
                  ),
                ),
                title: Text(
                  '${persona.nombre} ${persona.apellido}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(FontAwesomeIcons.phone, size: 14, color: _secondaryTextColor),
                    const SizedBox(width: 5),
                    Text(
                      persona.telefono,
                      style: TextStyle(color: _secondaryTextColor),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.edit, color: _primaryColor, size: 20), 
                      onPressed: () => _mostrarFormulario(persona: persona),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.trash, color: Colors.redAccent, size: 20), 
                      onPressed: () => _eliminarPersona(persona.id),
                      tooltip: 'Eliminar',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        backgroundColor: _primaryColor,
        tooltip: 'Agregar Persona',
        child: Icon(FontAwesomeIcons.plus, size: 25, color: Colors.white), 
      ),
    );
  }
}
