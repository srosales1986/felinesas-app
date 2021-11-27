import 'package:chicken_sales_control/src/pages/sale/build_sales_by_user.dart';
import 'package:flutter/material.dart';

class SalesByUserPage extends StatelessWidget {
  const SalesByUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas de:'),
      ),
      body: Container(child: BuildSalesByUser()),
    );
  }
}
