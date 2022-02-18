import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/models/payment_model.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/User_model.dart';

class SalesSummaryWidget extends StatelessWidget {
  final List<SaleToReport> salesList;
  final num totalCashInstallment;
  final num totalMpInstallment;
  final UserModel currentUser;

  SalesSummaryWidget({
    Key? key,
    required this.salesList,
    required this.totalCashInstallment,
    required this.totalMpInstallment,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dbProvider = Provider.of<FirebaseProvider>(context, listen: false);
    Stream<QuerySnapshot<Map<String, dynamic>>> _paymentsStream =
        _dbProvider.paymentsStream;

    num _curretTotalCashInstallment = totalCashInstallment;
    num _curretTotalMpInstallment = totalMpInstallment;

    // List<Payment> _paymentList = [];

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

              print(docs.length);
              // print(_paymentList);
              // _paymentList.forEach((element) {
              //   print(element.paymentAmount.toStringAsFixed(2));
              // });

              // if (_paymentList.isNotEmpty) {
              //   _paymentList.clear();
              // }

              docs.forEach((payment) {
                bool _isTheCurrentUser =
                    payment.get('user_id').toString() == currentUser.externalId;

                bool _isCreatedToday = Utils.formatDateWithoutHms(
                        DateTime.fromMillisecondsSinceEpoch(payment
                            .get('date_created')
                            .millisecondsSinceEpoch)) ==
                    Utils.formatDateWithoutHms(DateTime.now());

                if (_isTheCurrentUser && _isCreatedToday) {
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
                }
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            child: CardText(
              text: 'Total de ventas realizadas: ',
              total: salesList.length.toStringAsFixed(0),
            ),
          ),
          Card(
            elevation: 2,
            child: CardText(
              text: 'Total efectivo recibido: ',
              total: Utils.formatCurrency(totalCashInstallment),
            ),
          ),
          Card(
            elevation: 2,
            child: CardText(
              text: 'Total MercadoPago: ',
              total: Utils.formatCurrency(totalMpInstallment),
            ),
          ),
        ],
      ),
    );
  }
}

class CardText extends StatelessWidget {
  const CardText({
    Key? key,
    required this.total,
    required this.text,
  }) : super(key: key);

  final String total;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87),
          children: [
            TextSpan(
              text: text,
            ),
            TextSpan(
              text: total,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
