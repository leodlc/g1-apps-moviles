import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: Center(
        child: Text(
          'Esta es la pantalla de información',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
