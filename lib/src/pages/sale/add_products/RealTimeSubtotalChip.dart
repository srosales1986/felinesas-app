import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealTimeSubtotalChip extends StatelessWidget {
  const RealTimeSubtotalChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    return Text(
      'TOTAL: ' + Utils.formatCurrency(saleProvider.getSubTotal()),
      //'TOTAL: \$' + saleProvider.getSubTotal().toStringAsFixed(2),
      style: TextStyle(color: Colors.black54, fontSize: 18, shadows: [
        Shadow(
          blurRadius: 10,
          color: Colors.grey,
          offset: Offset(1, 1),
        ),
      ]),
    );
  }
}
