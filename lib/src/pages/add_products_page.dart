import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/services/ProductService.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddProductsPage extends StatefulWidget {
  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsProvider>(context, listen: true);
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    // final Sale sale = Sale();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nueva venta'),
      ),
      body: Scrollbar(
        child: ListView(
            children: ProductService.getProductsListTile(
                context, productsProvider.productList)),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 40)),
              enableFeedback: true,
              minimumSize: MaterialStateProperty.all(Size(0, 50)),
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              saleProvider.saleProductList.clear();
              print(saleProvider.saleProductList);
              Navigator.pushNamed(context, 'delivery_boy_home_page');
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 30)),
              enableFeedback: true,
              minimumSize: MaterialStateProperty.all(Size(0, 50)),
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            child: Text(
              'Finalizar venta',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.pushNamed(context, 'sale_detail');
              print(saleProvider.saleProductList);
            },
          ),
        ],
      ),
    );
  }
}
