// import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProductsProvider.dart';

// PRODUCT LISTVIEW
class ProductListView extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> productsCollection;
  // final currentCustomer;
  ProductListView({
    Key? key,
    // required this.currentCustomer,
    required this.productsCollection,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  void initState() {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    final productsCollection = widget.productsCollection;

    productsCollection.snapshots().listen((event) {
      List<Product> productList =
          event.docs.map((e) => Product.fromJson(e.id, e.data())).toList();

      productsProvider.productList = productList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: true);
    List<Product> productList = productsProvider.productList;
    // Customer currentCustomer = widget.currentCustomer;
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        if (productList.isEmpty) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return Column(
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.symmetric(horizontal: 6),
              minVerticalPadding: 1,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  // color: Colors.white60,
                  height: 55.0,
                  width: 55.0,
                  alignment: Alignment.center,
                  child: Text(
                    productList[index].initials,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      shadows: [
                        Shadow(
                            blurRadius: 5,
                            color: Colors.black38,
                            offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                ),
              ),
              title: Container(
                child: Text(
                  productList[index].name,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              trailing: Amount(
                productId: productList[index].id,
                // currentCustomer: currentCustomer,
                product: productList[index],
              ),
              subtitle: Text(
                  '\$${productList[index].priceByUnit.toStringAsFixed(2)}'),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}

class Amount extends StatelessWidget {
  final String productId;
  // final Customer currentCustomer;
  final Product product;
  Amount({
    Key? key,
    required this.productId,
    // required this.currentCustomer,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);
    // final saleProductList = saleProvider.saleProductList;
    final productId = this.productId;
    // final currentCustomer = this.currentCustomer;
    final product = this.product;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {
              saleProvider.subtractAmount(product);
            },
            icon: Icon(
              Icons.remove_circle,
              color: Colors.blue,
            )),
        Container(
          child: AmountNumber(productId: productId),
        ),
        IconButton(
            onPressed: () {
              saleProvider.addAmount(product);
            },
            icon: Icon(
              Icons.add_circle,
              color: Colors.blue,
            )),
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
