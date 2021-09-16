import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductService {
  static getProductsListTile(BuildContext context, Customer currentCustomer,
      List<Product> productList) {
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
            trailing: Amount(
              productId: product.id,
              currentCustomer: currentCustomer,
              product: product,
            ),
            subtitle: Text('\$${product.priceByUnit.toStringAsFixed(2)}'),
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
            trailing: Container(
              alignment: Alignment.centerLeft,
              width: 100,
              height: 60,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '\$${product.priceByUnit.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
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

class Amount extends StatelessWidget {
  final String productId;
  final Customer currentCustomer;
  final Product product;
  Amount({
    Key? key,
    required this.productId,
    required this.currentCustomer,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);
    // final saleProductList = saleProvider.saleProductList;
    final productId = this.productId;
    final currentCustomer = this.currentCustomer;
    final product = this.product;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () {
              saleProvider.subtractAmount(product);
            },
            icon: Icon(Icons.remove_circle)),
        Container(
          child: AmountNumber(productId: productId),
        ),
        IconButton(
            onPressed: () {
              saleProvider.addAmount(currentCustomer, product);
            },
            icon: Icon(Icons.add_circle)),
      ],
    );
  }
}

class AmountNumber extends StatelessWidget {
  final productId;
  const AmountNumber({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);
    var saleProductList = saleProvider.saleProductList;

    if (saleProductList.isEmpty ||
        !saleProductList.any((e) => e.containsKey(productId))) {
      return Text(
        '0',
        style: TextStyle(fontSize: 18),
      );
    }
    var _actualAmount = saleProductList
        .firstWhere((e) => e.containsKey(productId))
        .values
        .first
        .amount
        .toString();

    return Text(
      '$_actualAmount',
      style: TextStyle(fontSize: 18),
    );
  }
}
