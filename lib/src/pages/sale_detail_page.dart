import 'package:flutter/material.dart';

class SaleDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la venta'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(160),
          },
          children: [
            TableRow(
              children: [
                Center(child: Text('Producto')),
                Center(child: Text('Precio')),
                Center(child: Text('Cantidad')),
                Center(child: Text('Total')),
              ],
            ),
            TableRow(children: [
              Text('Pollo deshuesado Fadel sdf sd fds'),
              Center(child: Text('\$5.00')),
              Center(child: Text('4')),
              Center(child: Text('\$20.0')),
            ]),
          ],
        ),
      ),
    );
  }
}
