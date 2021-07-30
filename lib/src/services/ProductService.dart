import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:flutter/material.dart';

class ProductService {
  static getProductsListTile(List<Product> productList) {
    List<Widget> productsListTile = [];
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
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text('kg: \$${product.priceByKg.toStringAsFixed(2)}'),
                Text('Unidad: \$${product.priceByUnit.toStringAsFixed(2)}'),
              ],
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
              style: TextStyle(fontSize: 18),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${product.priceByUnit.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
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
