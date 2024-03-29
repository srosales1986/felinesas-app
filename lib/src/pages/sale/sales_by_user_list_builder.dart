import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/ReportSalesByUser.dart';
import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/pages/reports/salesSummaryWidget.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_repository_impl.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_repository.dart';
import 'package:chicken_sales_control/src/services/ReportProvider.dart';
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
    final reportProvider = Provider.of<ReportProvider>(context, listen: true);
    SalesRepository _salesRepository = SalesRepositoryImpl();

    Stream<QuerySnapshot<Map<String, dynamic>>> _salesStream =
        _salesRepository.getStreamSalesListByUserAndDate(
            widget.currentUser.externalId, reportProvider.selectedDate);
    print('Hora que se pasa al stream: ${reportProvider.selectedDate}');

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

                print('Cantidad de ventas: ${docs.length}');

                if (_salesList.isNotEmpty) {
                  _salesList.clear();
                }

                docs.forEach((sale) {
                  String dateFromFireBase = Utils.formatDateWithoutHms(
                      DateTime.fromMillisecondsSinceEpoch(
                          sale.get('date_created').millisecondsSinceEpoch));
                  String dateTo =
                      Utils.formatDateWithoutHms(reportProvider.selectedDate);

                  if (dateFromFireBase == dateTo) {
                    _salesList.add(SaleToReport.fromJson(sale.data()));
                  }
                });

                List<ReportSalesByUser> salesByUserList = [];
                Map<String, num> productsMap = {
                  'Efectivo recibido': 0,
                  'MercadoPago': 0
                };
                num totalCashInstallment = 0;
                num totalMpInstallment = 0;

                _salesList.forEach((sale) {
                  productsMap = {'Efectivo recibido': 0, 'MercadoPago': 0};
                  num oldCash = productsMap['Efectivo recibido']!;
                  num oldMP = productsMap['MercadoPago']!;

                  num newCash = oldCash + sale.cashInstallment;
                  num newMP = oldMP + sale.mpInstallment;
                  productsMap.update('Efectivo recibido', (value) => newCash);
                  productsMap.update('MercadoPago', (value) => newMP);

                  totalCashInstallment += sale.cashInstallment;
                  totalMpInstallment += sale.mpInstallment;

                  ReportSalesByUser currentCustomer = ReportSalesByUser(
                    customerName: sale.customerName,
                    salesReport: productsMap,
                  );

                  sale.productsList.forEach((product) {
                    String currentProduct = product.productName;

                    if (productsMap.containsKey(currentProduct)) {
                      num oldValue = productsMap[currentProduct]!;
                      num newValue = oldValue + product.amount;
                      productsMap.update(currentProduct, (value) => newValue);
                    } else {
                      productsMap.putIfAbsent(
                          currentProduct, () => product.amount);
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
                        selectedDate: reportProvider.selectedDate,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _salesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              num _total = _salesList[index].cashInstallment +
                                  _salesList[index].mpInstallment;

                              return Column(
                                children: [
                                  ListTile(
                                    title: Center(
                                      child: Text(
                                          '${_salesList[index].customerName}'),
                                    ),
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
                                                _salesList[index]
                                                    .cashInstallment)),
                                        Text('MercadoPago: ' +
                                            Utils.formatCurrency(
                                                _salesList[index]
                                                    .mpInstallment)),
                                        Text('Descuento: ' +
                                            Utils.formatCurrency(num.parse(
                                                _salesList[index].discount))),
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
