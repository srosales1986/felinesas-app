import 'package:chicken_sales_control/src/services/ProductService.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductsPage extends StatefulWidget {
  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Agregar Productos'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView(
            children: ProductService.getProductsListTile(
                productsProvider.productList)),
      ),
    );
  }
}
