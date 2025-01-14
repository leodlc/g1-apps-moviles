import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Pagos de Servicios Básicos'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.lightbulb),
          title: Text('Empresa Eléctrica'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('CNT'),
          onTap: () {},
        ),
      ],
    );
  }
}
