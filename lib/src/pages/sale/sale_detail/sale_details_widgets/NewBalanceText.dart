import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBalanceText extends StatelessWidget {
  const NewBalanceText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: true);
    saleProvider.updateNewBalance();

    return Container(
      color: Colors.grey,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        'SALDO ACTUAL: ' + Utils.formatCurrency(saleProvider.newBalance),
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
