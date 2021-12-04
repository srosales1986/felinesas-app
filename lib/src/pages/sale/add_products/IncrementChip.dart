import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncrementChip extends StatelessWidget {
  const IncrementChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: true);
    num increment = saleProvider.increment;

    return ActionChip(
      label: increment == 0.5
          ? Text('Sumar de a 0.5', style: TextStyle(color: Colors.black54))
          : Text('Sumar de a 1.0', style: TextStyle(color: Colors.black54)),
      onPressed: () => saleProvider.changeIncrement(),
    );
  }
}
