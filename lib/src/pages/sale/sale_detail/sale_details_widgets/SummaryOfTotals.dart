import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryOfTotals extends StatelessWidget {
  const SummaryOfTotals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final num _total =
        saleProvider.getSubTotal() + saleProvider.currentCustomer.balance;
    saleProvider.finalTotal = _total;
    saleProvider.currentSale.subtotal = saleProvider.getSubTotal();
    saleProvider.currentSale.total = saleProvider.finalTotal;

    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 10, right: 20.0, bottom: 1.0),
          child: Text(
            'Subtotal: ' + Utils.formatCurrency(saleProvider.getSubTotal()),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 10, right: 20.0, bottom: 1.0),
          child: Text(
            'Saldo anterior: ' +
                Utils.formatCurrency(saleProvider.currentCustomer.balance),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 10, right: 20.0, bottom: 1.0),
          child: Text(
            'TOTAL: ' + Utils.formatCurrency(_total),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
