import 'dart:core';
import 'package:chicken_sales_control/src/models/ProductForSale.dart';
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

              Map<String, num> productsMap = {
                'cashInstallment': 0,
                'mpInstallment': 0
              };

              _salesList.forEach((element) {
                num oldCash = productsMap['cashInstallment']!;
                num oldMP = productsMap['mpInstallment']!;

                num newCash = oldCash + element.cashInstallment;
                num newMP = oldMP + element.mpInstallment;
                productsMap.update('cashInstallment', (value) => newCash);
                productsMap.update('mpInstallment', (value) => newMP);

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
              });

              print(productsMap);

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _salesList.length,
                itemBuilder: (BuildContext context, int index) {
                  num _total = _salesList[index].cashInstallment +
                      _salesList[index].mpInstallment;

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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Efectivo: \$ ${_salesList[index].cashInstallment}'),
                                  Text(
                                      'MercadoPago: \$ ${_salesList[index].mpInstallment}'),
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
      },
    );
  }
}
