import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/services/ProductService.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
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
    Customer actualCustomer =
        ModalRoute.of(context)!.settings.arguments as Customer;
    var productsProvider = Provider.of<ProductsProvider>(context, listen: true);
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    // final Sale sale = Sale();

    return WillPopScope(
      onWillPop: (saleProvider.saleProductList.isNotEmpty) ? _onWillPop : null,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Chip(
                backgroundColor: Colors.amber,
                label: Text(
                  'TOTAL: \$' + saleProvider.getTotal().toStringAsFixed(2),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: true,
          title: Text('Nueva venta'),
        ),
        body: Scrollbar(
          child: ListView(
              physics: BouncingScrollPhysics(),
              children: ProductService.getProductsListTile(
                  context, actualCustomer, productsProvider.productList)),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // CancelSaleButton(saleProvider: saleProvider),
            ClearButton(saleProvider: saleProvider),
            DetailButton()
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    var saleProvider = Provider.of<SaleProvider>(context, listen: false);

    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Cancelar venta'),
                content: Text(
                    'Se perderán los datos cargados. ¿Cancelar de todos modos?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      saleProvider.saleProductList.clear();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Si'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                ],
              );
            }) ??
        false;
  }
}

class ClearButton extends StatelessWidget {
  final SaleProvider saleProvider;
  const ClearButton({
    required this.saleProvider,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        HapticFeedback.heavyImpact();
        saleProvider.clear();
        // Navigator.pushNamed(context, 'delivery_boy_home_page');
      },
      icon: Icon(Icons.restore),
      label: Text('Limpiar'),
    );
  }
}

class DetailButton extends StatelessWidget {
  const DetailButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        HapticFeedback.heavyImpact();
        Navigator.pushNamed(context, 'sale_detail');
      },
      child: Text(
        'Detalle',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class CancelSaleButton extends StatelessWidget {
  const CancelSaleButton({
    Key? key,
    required this.saleProvider,
  }) : super(key: key);

  final SaleProvider saleProvider;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        HapticFeedback.heavyImpact();
        saleProvider.saleProductList.clear();
        Navigator.pushNamed(context, 'delivery_boy_home_page');
      },
      icon: Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
