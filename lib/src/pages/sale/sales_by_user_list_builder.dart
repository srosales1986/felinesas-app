import 'dart:core';
import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/ReportSalesByUser.dart';
import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesByUserListBuilder extends StatefulWidget {
  final UserModel currentUser;
  SalesByUserListBuilder({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _SalesByUserListBuilderState createState() => _SalesByUserListBuilderState();
}

class _SalesByUserListBuilderState extends State<SalesByUserListBuilder> {
  @override
  Widget build(BuildContext context) {
    // final reportProvider = Provider.of<ReportProvider>(context, listen: true);
    final _dbProvider = Provider.of<FirebaseProvider>(context, listen: false);

    Stream<QuerySnapshot<Map<String, dynamic>>> _salesStream =
        _dbProvider.salesStream;

    List<SaleToReport> _salesList = [];

    return StreamBuilder(
        stream: _salesStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            case ConnectionState.none:
              return Center(child: Text('None'));

            case ConnectionState.done:
            case ConnectionState.active:
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                final docs = snapshot.data!.docs;
                print(docs.length);

                if (_salesList.isNotEmpty) {
                  _salesList.clear();
                }
                docs.forEach((sale) {
                  if (sale.get('user_seller')['external_id'].toString() ==
                      widget.currentUser.externalId) {
                    //       &&
                    // Utils.formatDateWithoutHms(
                    //         DateTime.fromMillisecondsSinceEpoch(sale
                    //             .get('date_created')
                    //             .millisecondsSinceEpoch)) ==
                    //     Utils.formatDateWithoutHms(DateTime.now())) {
                    _salesList.add(SaleToReport.fromJson(sale.data()));
                  }
                });

                List<ReportSalesByUser> salesByUserList = [];
                Map<String, num> productsMap = {
                  'Efectivo recibido': 0,
                  'MercadoPago': 0
                };

                _salesList.forEach((element) {
                  productsMap = {'Efectivo recibido': 0, 'MercadoPago': 0};
                  num oldCash = productsMap['Efectivo recibido']!;
                  num oldMP = productsMap['MercadoPago']!;

                  num newCash = oldCash + element.cashInstallment;
                  num newMP = oldMP + element.mpInstallment;
                  productsMap.update('Efectivo recibido', (value) => newCash);
                  productsMap.update('MercadoPago', (value) => newMP);

                  ReportSalesByUser currentCustomer = ReportSalesByUser(
                    customerName: element.customerName,
                    salesReport: productsMap,
                  );

                  element.productsList.forEach((element) {
                    String currentProduct = element.productName;

                    if (productsMap.containsKey(currentProduct)) {
                      num oldValue = productsMap[currentProduct]!;
                      num newValue = oldValue + element.amount;
                      productsMap.update(currentProduct, (value) => newValue);
                    } else {
                      productsMap.putIfAbsent(
                          currentProduct, () => element.amount);
                    }
                  });
                  salesByUserList.add(currentCustomer);
                });

                print(salesByUserList);

                if (_salesList.isEmpty) {
                  return Center(
                    child: Text(
                        '${widget.currentUser.userName} no realizó ventas hoy'),
                  );
                } else {
                  // List<Widget> widgetList = [];
                  // productsMap.entries.forEach((element) {
                  //   widgetList.add(ListTile(
                  //     dense: true,
                  //     title: RichText(
                  //       text: TextSpan(
                  //         style: TextStyle(fontSize: 16, color: Colors.black87),
                  //         children: [
                  //           TextSpan(
                  //               text: '${element.key}: ',
                  //               style: TextStyle(fontWeight: FontWeight.bold)),
                  //           TextSpan(text: '${element.value}'),
                  //         ],
                  //       ),
                  //     ),
                  //   ));
                  //   if (element.key == 'MercadoPago') {
                  //     widgetList.add(Divider());
                  //   }
                  // });

                  // return Scrollbar(
                  //   child: SingleChildScrollView(
                  //     child: Container(
                  //       margin:
                  //           EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisSize: MainAxisSize.max,
                  //         children: widgetList,
                  //       ),
                  //     ),
                  //   ),
                  // );
                  // }

                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _salesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      num _total = salesByUserList[index]
                              .salesReport['Efectivo recibido'] +
                          salesByUserList[index].salesReport['MercadoPago'];

                      return _salesList.isEmpty
                          ? Center(
                              child: Text(
                                  '${widget.currentUser.userName} no hay realizó ventas hoy'),
                            )
                          : Column(
                              children: [
                                ListTile(
                                  title: Center(
                                      child: Text(
                                          '${_salesList[index].customerName}')),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      listOfProducts(
                                          _salesList[index].productsList),
                                      Text(
                                          'Efectivo: \$ ${salesByUserList[index].salesReport['Efectivo recibido']}'),
                                      Text(
                                          'MercadoPago: \$ ${salesByUserList[index].salesReport['MercadoPago']}'),
                                      Text('Total recibido: \$' +
                                          _total.toStringAsFixed(2)),
                                      Text(
                                        Utils.formatDateWithoutHms(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                _salesList[index]
                                                    .dateCreated
                                                    .millisecondsSinceEpoch)),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                    },
                  );
                }
              }
          }
        });
  }

  Widget listOfProducts(List<ProductForSale> productsList) {
    String text = 'Productos: ';
    productsList.forEach((product) {
      text = text +
          product.productInitials +
          '(' +
          product.amount.toStringAsPrecision(2) +
          ')' +
          ' ';
    });
    return Text(text);
  }
}
