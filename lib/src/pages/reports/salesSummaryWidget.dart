import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/models/payment_model.dart';
import 'package:chicken_sales_control/src/pages/reports/sold_products_table_page.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_repository.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/User_model.dart';
import '../sale/sales_repository_impl.dart';

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
    SalesRepository _salesRepository = SalesRepositoryImpl();

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
                String dateFromFireBase = Utils.formatDateWithoutHms(
                    DateTime.fromMillisecondsSinceEpoch(
                        payment.get('date_created').millisecondsSinceEpoch));
                String dateTo = Utils.formatDateWithoutHms(selectedDate);

                if (dateFromFireBase == dateTo) {
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
    Map productsMap = {};
    List<ProductForSale> productsBySaleList = [];
    salesList.forEach(
      (sale) {
        sale.productsList.forEach((product) {
          productsBySaleList.add(product);
        });
      },
    );
    productsBySaleList.forEach((product) {
      String productName = product.productName;
      productsMap.putIfAbsent(
          '$productName',
          () => {
                'initials': '${product.productInitials}',
                'price': product.price,
                'amount': num.parse('0.0'),
                'subtotal': num.parse('0.0')
              });
      num oldValue = productsMap[productName]['subtotal'];
      num newValue = oldValue + product.subtotal;
      num oldAmount = productsMap[productName]['amount'];
      num newAmount = oldAmount + product.amount;
      productsMap[productName].update('subtotal', (value) => newValue);
      productsMap[productName].update('amount', (value) => newAmount);
    });

    print(productsMap);
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
                  imgPath: 'assets/images/mp.png',
                  total: Utils.formatCurrency(totalMpInstallment),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white),
              padding: MaterialStateProperty.resolveWith((states) =>
                  EdgeInsets.symmetric(horizontal: 80, vertical: 15)),
              elevation: MaterialStateProperty.resolveWith((states) => 3),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        SoldProductsTablePage(productsMap: productsMap)))),
            child: Text('Productos vendidos'),
          ),
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    Key? key,
    required this.total,
    this.icon,
    this.imgPath,
  }) : super(key: key);

  final String total;
  final IconData? icon;
  final String? imgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon == null
              ? Container(
                  child: Image(
                  image: AssetImage(imgPath!),
                  width: 32,
                ))
              : Icon(icon, color: Colors.green.shade800),
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
