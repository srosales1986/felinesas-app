import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/models/payment_model.dart';
import 'package:chicken_sales_control/src/pages/reports/expansionPanelProductsList.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_repository.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/User_model.dart';
import '../sale/sales_data_fetch.dart';

class SalesSummaryWidget extends StatelessWidget {
  final List<SaleToReport> salesList;
  final num totalCashInstallment;
  final num totalMpInstallment;
  final UserModel currentUser;
  final DateTime selectedDate;

  SalesSummaryWidget({
    Key? key,
    required this.salesList,
    required this.totalCashInstallment,
    required this.totalMpInstallment,
    required this.currentUser,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SalesRepository _salesRepository = SalesDataFetch();

    Stream<QuerySnapshot<Map<String, dynamic>>> _paymentsStream =
        _salesRepository.getStreamPaymentsByUserAndDate(
            currentUser.externalId, selectedDate);

    num _curretTotalCashInstallment = totalCashInstallment;
    num _curretTotalMpInstallment = totalMpInstallment;

    return StreamBuilder(
      stream: _paymentsStream,
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

              print('Cantidad de pagos recibidos: ${docs.length}');

              docs.forEach((payment) {
                if (Payment.fromJson(payment.data()).methodOfPayment ==
                    'Efectivo') {
                  _curretTotalCashInstallment +=
                      Payment.fromJson(payment.data()).paymentAmount;
                }
                if (Payment.fromJson(payment.data()).methodOfPayment ==
                    'MercadoPago') {
                  _curretTotalMpInstallment +=
                      Payment.fromJson(payment.data()).paymentAmount;
                }
                // _paymentList.add(Payment.fromJson(payment.data()));
              });
              return SummaryWidget(
                salesList: salesList,
                totalCashInstallment: _curretTotalCashInstallment,
                totalMpInstallment: _curretTotalMpInstallment,
              );
            }
        }
      },
    );
  }
}

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({
    Key? key,
    required this.salesList,
    required this.totalCashInstallment,
    required this.totalMpInstallment,
  }) : super(key: key);

  final List<SaleToReport> salesList;
  final num totalCashInstallment;
  final num totalMpInstallment;

  @override
  Widget build(BuildContext context) {
    Map productsMap = {};
    List<ProductForSale> productsBySaleList = [];
    salesList.forEach(
      (sale) {
        sale.productsList.forEach((product) {
          productsBySaleList.add(product);
        });
      },
    );
    productsBySaleList.forEach(
      (product) {
        if (!productsMap.containsKey(product.productInitials)) {
          productsMap.addAll({'${product.productInitials}': product.subtotal});
        } else {
          num oldValue = productsMap[product.productInitials];
          num newValue = oldValue + product.subtotal;
          productsMap.update(product.productInitials, (value) => newValue);
        }
      },
    );
    print(productsMap);
    List<Widget> chipList = [];
    productsMap.forEach((key, value) {
      chipList.add(Chip(
        backgroundColor: Colors.blue.shade200,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), side: BorderSide.none),
        labelPadding: EdgeInsets.symmetric(horizontal: 1),
        // padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        elevation: 2,
        labelStyle: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        label: Text('$key:  ${Utils.formatCurrency(value)}'),
      ));
    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 2,
            child: CardContent(
              icon: Icons.auto_awesome_motion_outlined,
              total:
                  'Cantidad de ventas: ${salesList.length.toStringAsFixed(0)}',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                elevation: 2,
                child: CardContent(
                  icon: Icons.money_rounded,
                  total: Utils.formatCurrency(totalCashInstallment),
                ),
              ),
              Card(
                elevation: 2,
                child: CardContent(
                  icon: Icons.monetization_on,
                  total: Utils.formatCurrency(totalMpInstallment),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          ExpansionPanelProductsList(chipList: chipList),

          // Wrap(
          //   spacing: 5.0,
          //   alignment: WrapAlignment.center,
          //   children: chipList,
          // ),
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    Key? key,
    required this.total,
    required this.icon,
  }) : super(key: key);

  final String total;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(width: 5),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black87),
              children: [
                TextSpan(
                  text: total,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
