import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

// TODO: Mostrar lista de clientes o repartidores para acceder a las ventas de c/u.
class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: Container(
        child: Center(
          child: Text('Lista de ventas'),
        ),
      ),
    );
  }
}
