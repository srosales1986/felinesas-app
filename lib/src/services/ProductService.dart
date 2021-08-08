import 'package:animate_do/animate_do.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductService {
  static getProductsListTile(BuildContext context, List<Product> productList) {
    List<Widget> productsListTile = [];
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    Widget amount(List<Map<String, int>> saleProductList, Product product) {
      if (saleProductList.isEmpty ||
          !saleProductList.any((e) => e.containsKey(product.id))) {
        return Text(
          '0',
          style: TextStyle(fontSize: 18),
        );
      }
      var _actualAmount = saleProductList
          .firstWhere((e) => e.containsKey(product.id))
          .values
          .first
          .toString();
      return Text(
        '$_actualAmount',
        style: TextStyle(fontSize: 18),
      );
    }

    productList.forEach((product) {
      productsListTile.add(Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            minVerticalPadding: 1,
            leading: CircleAvatar(
              backgroundColor: Color(0xFFadcbff),
              radius: 27,
              child: Text(
                product.initials,
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              product.name,
              style: TextStyle(fontSize: 18),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      saleProvider.subtractAmount(product);
                      print(saleProvider.saleProductList);
                    },
                    icon: Icon(Icons.remove_circle)),
                Container(
                  child: amount(saleProvider.saleProductList, product),
                ),
                IconButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      saleProvider.addAmount(product);
                      print(saleProvider.saleProductList);
                    },
                    icon: Icon(Icons.add_circle)),
              ],
            ),
            subtitle: Text('\$${product.priceByUnit.toStringAsFixed(2)}'),
          ),
          Divider(),
        ],
      ));
    });

    return productsListTile;
  }

  static getProductsListTileSimple(List<Product> productList) {
    List<Widget> productsListTile = [];
    productList.forEach((product) {
      productsListTile.add(Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            minVerticalPadding: 0.1,
            title: Text(
              product.name,
              style: TextStyle(fontSize: 16),
            ),
            trailing: Container(
              width: 60,
              height: 20,
              // padding: EdgeInsets.only(left: 0),
              child: Text(
                '\$${product.priceByUnit.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.lightBlue,
                  shadows: [
                    Shadow(
                      color: Colors.blue,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Divider(),
        ],
      ));
    });
    return productsListTile;
  }

  static getPriceList(List<Product> productList) {
    List<Widget> productsListTile = [];
    productList.forEach((product) {
      productsListTile.add(Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            minVerticalPadding: 1,
            title: Text(
              product.name,
              style: TextStyle(fontSize: 20),
            ),
            trailing: Container(
              alignment: Alignment.centerLeft,
              width: 100,
              height: 60,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '\$${product.priceByUnit.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blueAccent,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 5,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text('kg: \$${product.priceByKg.toStringAsFixed(2)}'),
              ],
            ),
          ),
          Divider(),
        ],
      ));
    });
    return productsListTile;
  }
}
