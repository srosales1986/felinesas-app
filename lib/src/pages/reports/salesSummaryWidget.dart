import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:flutter/material.dart';

class SalesSummaryWidget extends StatelessWidget {
  final List<SaleToReport> salesList;
  final num totalCashInstallment;
  final num totalMpInstallment;

  SalesSummaryWidget({
    Key? key,
    required this.salesList,
    required this.totalCashInstallment,
    required this.totalMpInstallment,
  }) : super(key: key);

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
              total: '\$$totalCashInstallment',
            ),
          ),
          Card(
            elevation: 2,
            child: CardText(
              text: 'Total MercadoPago: ',
              total: '\$$totalMpInstallment',
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
