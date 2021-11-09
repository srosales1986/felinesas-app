import 'package:chicken_sales_control/src/custom_widgets/confirmation_dialog.dart';
import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class AddProductsPage extends StatefulWidget {
  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  bool swithValue = false;
  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final _db = Provider.of<FirebaseProvider>(context, listen: false);
    final _firebaseInstance = _db.fbInstance;
    num increment = saleProvider.increment;

    saleProvider.currentCustomer =
        ModalRoute.of(context)!.settings.arguments as Customer;

    Customer currentCustomer = saleProvider.currentCustomer;

    // final Sale sale = Sale();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Chip(
              backgroundColor: Colors.amber,
              label: SubTotalChip(),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text('Cliente: ${currentCustomer.name}'),
        bottom: PreferredSize(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Chip(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                      label: increment == 0.5 ? Text('+0.5') : Text('+1'),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  Switch(
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      value: swithValue,
                      onChanged: (value) => setState(() {
                            if (value) {
                              saleProvider.increment = 0.5;
                              swithValue = !swithValue;
                            } else {
                              saleProvider.increment = 1.0;
                              swithValue = !swithValue;
                            }
                          })),
                ],
              ),
            ),
            preferredSize: Size(10, 40)),
      ),
      body: Scrollbar(
        child: ProductListView(
          // currentCustomer: currentCustomer,
          productsCollection: _firebaseInstance.collection('products'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CancelSaleButton(saleProvider: saleProvider),
            ClearButton(saleProvider: saleProvider),
            DetailButton(),
          ],
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                SUBTOTAL CHIP                               */
/* -------------------------------------------------------------------------- */

class SubTotalChip extends StatelessWidget {
  const SubTotalChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);
    return Text(
      'TOTAL: \$' + saleProvider.getSubTotal().toStringAsFixed(2),
      style: TextStyle(fontSize: 12),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                CLEAR BUTTON                                */
/* -------------------------------------------------------------------------- */

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

/* -------------------------------------------------------------------------- */
/*                                DETAIL BUTTON                               */
/* -------------------------------------------------------------------------- */
class DetailButton extends StatelessWidget {
  const DetailButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        HapticFeedback.heavyImpact();
        Navigator.pushNamed(context, 'sale_detail_and_finish_sale_page');
      },
      child: Text(
        'Detalle',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                CANCEL BUTTON                               */
/* -------------------------------------------------------------------------- */

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
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return BounceInUp(
                  duration: Duration(milliseconds: 200),
                  child: ConfirmationDialog(
                    title: 'Cancelar venta',
                    contentText: '¿Está seguro que desea cancelar la venta?',
                    navigateTo: 'new_sale_page',
                    yesFunction: saleProvider.saleProductList.clear,
                  ),
                );
              });
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ));
  }
}
