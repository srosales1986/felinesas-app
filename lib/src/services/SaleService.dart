import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/invoice_model.dart';
import 'package:chicken_sales_control/src/pdf/pdf_api.dart';
import 'package:chicken_sales_control/src/pdf/pdf_invoice_api.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/sales_sheets_api.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'SaleProvider.dart';
import 'UserProvider.dart';

class SaleService {
  static Future<dynamic> showCloseSaleDialog(
      BuildContext context,
      Customer currentCustomer,
      List<ProductForSale> productList,
      num _finalTotal) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ElasticIn(
          duration: Duration(milliseconds: 200),
          child: Center(
            child: AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Center(
                child: Text('Finalizar venta'),
              ),
              content: FutureBuilder(
                future: closeSale(currentCustomer, productList, context),
                builder: (context, snapshot) {
                  final saleProvider =
                      Provider.of<SaleProvider>(context, listen: false);
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          SizedBox(height: 10.0),
                          Text('Conectando con la base de datos...'),
                        ],
                      );
                    case ConnectionState.active:
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
                    case ConnectionState.done:
                      if (snapshot.hasError || snapshot.data == 'error') {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElasticIn(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                            Text(snapshot.data.toString()),
                            Container(
                              child: TextButton(
                                style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(300, 60)),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop(false);
                                },
                                child: Container(child: Text('OK')),
                              ),
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
                                onPressed: () async {
                                  // Navigator.pushReplacementNamed(
                                  //     context, 'delivery_boy_home_page');

                                  final invoice = Invoice(
                                    info: InvoiceInfo(
                                      date:
                                          saleProvider.currentSale.dateCreated,
                                      customerName:
                                          saleProvider.currentCustomer.name,
                                      sellerName:
                                          userProvider.currentUser.userName,
                                      subtotal:
                                          saleProvider.currentSale.subtotal,
                                      beforeBalance:
                                          saleProvider.currentCustomer.balance,
                                      finalBalance: saleProvider.newBalance,
                                      total: saleProvider.finalTotal,
                                      cashIstallment:
                                          saleProvider.cashInstallment,
                                      mpInstallment: saleProvider.mpInstallment,
                                      discount: saleProvider.discount,
                                    ),
                                    items: saleProvider.saleProductList
                                        .map((e) => InvoiceItem(
                                            productName:
                                                e.values.first.productName,
                                            quantity: e.values.first.amount,
                                            unitPrice: e.values.first.price,
                                            total: e.values.first.subtotal))
                                        .toList(),
                                  );
                                  saleProvider.clearInstallments();
                                  saleProvider.clearCurrentSale();
                                  saleProvider.clear();

                                  Navigator.pushReplacementNamed(
                                      context, 'delivery_boy_home_page');

                                  final pdfFile =
                                      await PdfInvoiceApi.generate(invoice);
                                  PdfApi.openFile(pdfFile);

                                  // Navigator.of(context).pop(false);
                                },
                                child: Container(child: Text('OK')),
                              ),
                            ),
                          ],
                        );
                      }
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(snapshot.error.toString()),
                      ),
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

  static Future<String> closeSale(Customer currentCustomer,
      List<ProductForSale> productList, BuildContext context) async {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final fbInstance = Provider.of<FirebaseProvider>(context, listen: false);
    // final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    List<String> dataToSheet = [];

    Future<String> getJson() {
      return rootBundle.loadString('android/gsheets-332502-a250b4fa3976.json');
    }

    try {
      final Map<String, dynamic> _credentials = json.decode(await getJson());
      // Map<String, dynamic> _credentials = configProvider.currentConfig.toJson();
      print(_credentials);

      await SalesSheetsApi.init(currentCustomer.name, _credentials);

      // saleProvider.currentSale.customerId = currentCustomer.id;

      // saleProvider.currentSale.customerName = currentCustomer.name;

      // saleProvider.currentSale.productsList = productList;

      // saleProvider.currentSale.discount = saleProvider.discount;

      // saleProvider.currentSale.cashInstallment = saleProvider.cashInstallment;

      // saleProvider.currentSale.mpInstallment = saleProvider.mpInstallment;

      // saleProvider.currentSale.total = saleProvider.finalTotal;

      // saleProvider.currentSale.balanceBeforeSale = currentCustomer.balance;

      // saleProvider.currentSale.balanceAfterSale = saleProvider.newBalance;

      saleProvider.currentSale.dateCreated = DateTime.now();

      // saleProvider.currentSale.total = saleProvider.calculatedTotal;
      dataToSheet.add('Venta');
      dataToSheet.add(saleProvider.currentSale.userSeller.userName);
      dataToSheet.add(Utils.formatDate(saleProvider.currentSale.dateCreated));
      // String products = '';

      StringBuffer products = StringBuffer();
      int i = 0;
      saleProvider.saleProductList.forEach((e) {
        i++;
        products.write(e.entries.first.value.productInitials);
        products.write('(');
        products.write(e.entries.first.value.amount);
        products.write(')');
        if (saleProvider.currentSale.productsList.length > i) {
          products.write(' - ');
        }
      });
      dataToSheet.add(products.toString());
      dataToSheet.add(saleProvider.currentSale.subtotal.toStringAsFixed(2));
      dataToSheet.add(saleProvider.currentCustomer.balance.toStringAsFixed(2));
      dataToSheet.add(saleProvider.currentSale.total.toStringAsFixed(2));
      dataToSheet.add(saleProvider.currentSale.installment.toStringAsFixed(2));
      dataToSheet
          .add(saleProvider.currentSale.mpInstallment.toStringAsFixed(2));
      dataToSheet.add(saleProvider.currentSale.discount.toStringAsFixed(2));
      dataToSheet.add(saleProvider.newBalance.toStringAsFixed(2));
      await SalesSheetsApi.newRow(dataToSheet);

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
      // saleProvider.clear();
      return 'saved';
    } catch (e) {
      print(e);
      return 'error';
    }
  }
}
