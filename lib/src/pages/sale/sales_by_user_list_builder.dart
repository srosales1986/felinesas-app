// import 'dart:core';
import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/ReportSalesByUser.dart';
import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/pages/reports/salesSummaryWidget.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_data_fetch.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_repository.dart';
// import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class SalesByUserListBuilder extends StatefulWidget {
  final UserModel currentUser;
  final DateTime selectedDate;
  SalesByUserListBuilder({
    Key? key,
    required this.currentUser,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _SalesByUserListBuilderState createState() => _SalesByUserListBuilderState();
}

class _SalesByUserListBuilderState extends State<SalesByUserListBuilder> {
  @override
  Widget build(BuildContext context) {
    // final reportProvider = Provider.of<ReportProvider>(context, listen: true);
    // final _dbProvider = Provider.of<FirebaseProvider>(context, listen: false);
    SalesRepository _salesRepository = SalesDataFetch();

    Stream<QuerySnapshot<Map<String, dynamic>>> _salesStream =
        _salesRepository.getStreamSalesListByUserAndDate(
            widget.currentUser.externalId, widget.selectedDate);

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

                // docs.forEach((sale) {
                //   if (sale.get('user_seller')['external_id'].toString() ==
                //       widget.currentUser.externalId) {
                //     _salesList.add(SaleToReport.fromJson(sale.data()));
                //   }
                // });

                docs.forEach((sale) {
                  _salesList.add(SaleToReport.fromJson(sale.data()));
                  // bool _isTheCurrentUser =
                  //     sale.get('user_seller')['external_id'].toString() ==
                  //         widget.currentUser.externalId;

                  // bool isCreatedToday = Utils.formatDateWithoutHms(
                  //         DateTime.fromMillisecondsSinceEpoch(sale
                  //             .get('date_created')
                  //             .millisecondsSinceEpoch)) ==
                  //     Utils.formatDateWithoutHms(DateTime.now());

                  // if (_isTheCurrentUser && isCreatedToday) {
                  //   _salesList.add(SaleToReport.fromJson(sale.data()));
                  // }
                });

                List<ReportSalesByUser> salesByUserList = [];
                Map<String, num> productsMap = {
                  'Efectivo recibido': 0,
                  'MercadoPago': 0
                };
                num totalCashInstallment = 0;
                num totalMpInstallment = 0;

                _salesList.forEach((element) {
                  productsMap = {'Efectivo recibido': 0, 'MercadoPago': 0};
                  num oldCash = productsMap['Efectivo recibido']!;
                  num oldMP = productsMap['MercadoPago']!;

                  num newCash = oldCash + element.cashInstallment;
                  num newMP = oldMP + element.mpInstallment;
                  productsMap.update('Efectivo recibido', (value) => newCash);
                  productsMap.update('MercadoPago', (value) => newMP);

                  totalCashInstallment += element.cashInstallment;
                  totalMpInstallment += element.mpInstallment;

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

                _salesList
                    .sort(((a, b) => b.dateCreated.compareTo(a.dateCreated)));

                print(
                    'Efectivo: $totalCashInstallment, MP: $totalMpInstallment');

                if (_salesList.isEmpty) {
                  return Center(
                    child: Text(
                        '${widget.currentUser.userName} no realizó ventas hoy.'),
                  );
                } else {
                  return Column(
                    children: [
                      SalesSummaryWidget(
                        currentUser: widget.currentUser,
                        salesList: _salesList,
                        totalCashInstallment: totalCashInstallment,
                        totalMpInstallment: totalMpInstallment,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Expanded(
                        child: Container(
                          child: Scrollbar(
                            interactive: true,
                            isAlwaysShown: true,
                            thickness: 8,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _salesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                num _total = salesByUserList[index]
                                        .salesReport['Efectivo recibido'] +
                                    salesByUserList[index]
                                        .salesReport['MercadoPago'];

                                return Column(
                                  children: [
                                    ListTile(
                                      title: Center(
                                          child: Text(
                                              '${_salesList[index].customerName}')),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Utils.formatDate(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    _salesList[index]
                                                        .dateCreated
                                                        .millisecondsSinceEpoch)),
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          listOfProducts(
                                              _salesList[index].productsList),
                                          Text('Efectivo: ' +
                                              Utils.formatCurrency(
                                                  salesByUserList[index]
                                                          .salesReport[
                                                      'Efectivo recibido'])),
                                          Text('MercadoPago: ' +
                                              Utils.formatCurrency(
                                                  salesByUserList[index]
                                                          .salesReport[
                                                      'MercadoPago'])),
                                          Text('Total recibido: ' +
                                              Utils.formatCurrency(_total)),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
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
