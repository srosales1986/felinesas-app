import 'package:chicken_sales_control/src/custom_widgets/confirmation_dialog.dart';
import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/pages/sale_detail/sale_details_widgets/SaleDetailDataTable.dart';
import 'package:chicken_sales_control/src/pages/sale_detail/sale_details_widgets/SubtotalAndTotalCalculate.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class SaleDetailAndFinishPage extends StatefulWidget {
  @override
  State<SaleDetailAndFinishPage> createState() =>
      _SaleDetailAndFinishPageState();
}

class _SaleDetailAndFinishPageState extends State<SaleDetailAndFinishPage> {
  final _installmentController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  @override
  void dispose() {
    this._installmentController.dispose();
    this._discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<ProductForSale> productList = [];
    saleProvider.saleProductList.forEach((e) {
      productList.add(e.values.first);
    });
    final Customer currentCustomer = saleProvider.currentCustomer;

    saleProvider.currentSale.subtotal = saleProvider.getSubTotal();
    saleProvider.currentSale.userSeller = userProvider.currentUser;

    var _calculatedTotal = saleProvider.calculatedTotal;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detalle de la venta V2'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SaleDetailDataTable(productList: productList),
            Divider(),
            SubtotalAndTotalCalculate(currentCustomer: currentCustomer),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                color: Colors.green.shade500,
                child: TextButton(
                  child: Text(
                    'Finalizar venta',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      title: 'Finalizar venta',
                      contentText: '¿Cerrar la venta definitivamente?',
                      yesFunction: () => showCloseSaleDialog(
                        context,
                        currentCustomer,
                        productList,
                        _calculatedTotal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showCloseSaleDialog(
      BuildContext context,
      Customer currentCustomer,
      List<ProductForSale> productList,
      num _finalTotal) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return ElasticIn(
          duration: Duration(milliseconds: 200),
          child: Center(
            child: AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Center(
                child: Text('Guardando cambios...'),
              ),
              content: FutureBuilder(
                future: closeSale(currentCustomer, productList),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(snapshot.error.toString()),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElasticIn(
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                        Container(
                          child: TextButton(
                            style: ButtonStyle(
                              fixedSize:
                                  MaterialStateProperty.all(Size(300, 60)),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, 'pdf_page');
                              // Navigator.of(context).pop(false);
                            },
                            child: Container(child: Text('OK')),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      SizedBox(height: 10.0),
                      Text('Guardando...'),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> closeSale(
      Customer currentCustomer, List<ProductForSale> productList) async {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final fbInstance = Provider.of<FirebaseProvider>(context, listen: false);

    saleProvider.currentSale.customerId = currentCustomer.id;

    saleProvider.currentSale.productsList = productList;

    saleProvider.currentSale.discount = saleProvider.discount;

    saleProvider.currentSale.cashInstallment = saleProvider.cashInstallment;

    saleProvider.currentSale.mpInstallment = saleProvider.mpInstallment;

    saleProvider.currentSale.total = saleProvider.finalTotal;

    saleProvider.currentSale.balanceBeforeSale = currentCustomer.balance;

    saleProvider.currentSale.balanceAfterSale = saleProvider.newBalance;

    saleProvider.currentSale.dateCreated = DateTime.now();

    // saleProvider.currentSale.total = saleProvider.calculatedTotal;

    await fbInstance.fbSalesCollectionRef
        .doc()
        .set(saleProvider.currentSale.toMap(saleProvider.currentSale));

    await fbInstance.fbCustomersCollectionRef
        .doc(currentCustomer.id)
        .update({'balance': saleProvider.newBalance});

    updateProductsAmoun() async {
      productList.forEach((productForSale) {
        fbInstance.fbProductsCollectionRef
            .doc(productForSale.productId)
            .update({'availability_in_deposit': productForSale.finalAmount});
        print('${productForSale.productId} ${productForSale.finalAmount}');
      });
    }

    await updateProductsAmoun();

    // print(saleProvider.currentSale.toMap(saleProvider.currentSale));
    // print(saleProvider.currentSale.userSeller.userName);

    return 'saved';
  }
}
