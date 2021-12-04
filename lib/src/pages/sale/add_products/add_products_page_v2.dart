import 'package:animate_do/animate_do.dart';
import 'package:chicken_sales_control/src/custom_widgets/confirmation_dialog.dart';
import 'package:chicken_sales_control/src/pages/sale/add_products/IncrementChip.dart';
import 'package:chicken_sales_control/src/pages/sale/add_products/RealTimeSubtotalChip.dart';
import 'package:chicken_sales_control/src/services/ProductService.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddProductsPage2 extends StatelessWidget {
  const AddProductsPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: true);

    // saleProvider.currentCustomer =
    //     ModalRoute.of(context)!.settings.arguments as Customer;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Agregar productos'),
        bottom: PreferredSize(
          child: Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                    child: Chip(
                      backgroundColor: Colors.blue.shade300,
                      label: RealTimeSubtotalChip(),
                    ),
                  ),
                  IncrementChip(),
                ],
              ),
            ),
          ),
          preferredSize: Size(10, 30),
        ),
      ),
      body: Scrollbar(
        child: ProductListView(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
/*                                CLEAR BUTTON                                */
/* -------------------------------------------------------------------------- */

class ClearButton extends StatelessWidget {
  final SaleProvider saleProvider;
  const ClearButton({
    required this.saleProvider,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: TextButton.icon(
        onPressed: () {
          HapticFeedback.heavyImpact();
          saleProvider.clear();
          // Navigator.pushNamed(context, 'delivery_boy_home_page');
        },
        icon: Icon(
          Icons.restore,
          color: Colors.green,
        ),
        label: Text(
          'Limpiar',
          style: TextStyle(color: Colors.green),
        ),
      ),
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
    final saleProvider = Provider.of<SaleProvider>(context, listen: true);
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: saleProvider.saleProductList.isEmpty
              ? null
              : MaterialStateProperty.all(Colors.green),
        ),
        onPressed: () {
          if (saleProvider.saleProductList.isEmpty) {
            HapticFeedback.heavyImpact();
            return;
          }
          Navigator.pushReplacementNamed(context, 'sale_details');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            'Detalle',
            style: TextStyle(
              fontSize: 18,
              color: saleProvider.saleProductList.isEmpty
                  ? Colors.grey
                  : Colors.white,
            ),
          ),
        ),
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
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: IconButton(
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
          )),
    );
  }
}
