import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/pages/sale/add_products/BuildTrailing.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProductsProvider.dart';

// PRODUCT LISTVIEW
class ProductListView extends StatefulWidget {
  // final CollectionReference<Map<String, dynamic>> productsCollection;
  // final currentCustomer;
  ProductListView({
    Key? key,
    // required this.currentCustomer,
    // required this.productsCollection,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  void initState() {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    final _db = Provider.of<FirebaseProvider>(context, listen: false);

    final productsCollection = _db.fbProductsCollectionRef;

    productsCollection.snapshots().listen((event) {
      List<Product> productList =
          event.docs.map((e) => Product.fromJson(e.id, e.data())).toList();

      productsProvider.productList = productList;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            SizedBox(height: 10),
            ListTile(
                enabled: productList[index].availabilityInDeposit != 0,
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
                trailing: productList[index].availabilityInDeposit != 0
                    ? BuildTrailing(product: productList[index])
                    : null,
                subtitle: productList[index].isWeighed
                    ? Text(Utils.formatCurrency(productList[index].priceByKg) +
                        ' - Stock: ${productList[index].availabilityInDeposit.toStringAsFixed(2)}Kg')
                    : Text(Utils.formatCurrency(
                            productList[index].priceByUnit) +
                        ' - Stock: ${productList[index].availabilityInDeposit.toStringAsFixed(0)}')),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                saleProvider.subtractAmount(product);
              },
              icon: Icon(
                Icons.remove_circle,
                color: Colors.grey,
                size: 30,
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
                color: Colors.blue.shade400,
                size: 30,
              )),
        ],
      ),
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
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        margin: EdgeInsets.symmetric(horizontal: 17),
        child: Text(
          '0',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    var _currentAmount = saleProductList
        .firstWhere((e) => e.containsKey(productId))
        .values
        .first
        .amount
        .toString();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '$_currentAmount',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
