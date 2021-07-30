import 'package:flutter/material.dart';

class LoadPage extends StatelessWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text('Registro de carga'),
      ),
      body: Center(
        child: Text('De aca va el registro de lo que cargan el el vehículo'),
      ),
    );
  }
}
