import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar Provider
import '../../logical/crud_usuario.dart';
import '../admin/admin_creacion_usuario.dart';
import '../admin/admin_editar_usuario.dart';

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({Key? key}) : super(key: key);

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  @override
  void initState() {
    super.initState();
    // Llama al método para obtener usuarios al iniciar
    Future.microtask(() {
      Provider.of<UserCrudController>(context, listen: false).getAllUsers();
    });
  }

  Future<void> _mostrarVentanaCrearUsuario(BuildContext context) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => const AdminCreacionUsuario(),
    );

    if (resultado == true) {
      // Recarga usuarios después de crear uno nuevo
      Provider.of<UserCrudController>(context, listen: false).getAllUsers();
    }
  }

  Future<void> _mostrarVentanaEditarUsuario(
      BuildContext context, Map<String, dynamic> usuario) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => AdminEditarUsuario(usuario: usuario),
    );

    if (resultado == true) {
      // Muestra una notificación de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario actualizado exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _mostrarVentanaCrearUsuario(context),
          ),
        ],
      ),
      body: Consumer<UserCrudController>(
        builder: (context, controller, child) {
          return ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: controller.userListNotifier,
            builder: (context, userList, _) {
              if (userList.isEmpty) {
                return const Center(child: Text('No hay usuarios disponibles'));
              }

              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final usuario = userList[index];
                  return ListTile(
                    title: Text(usuario['username']),
                    subtitle: Text(usuario['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _mostrarVentanaEditarUsuario(context, usuario),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await controller
                                  .deleteUser(usuario['id'].toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Usuario eliminado exitosamente')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Error al eliminar usuario: $e')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
