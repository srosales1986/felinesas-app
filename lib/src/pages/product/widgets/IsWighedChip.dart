import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IsWeighedChip extends StatelessWidget {
  const IsWeighedChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: true);

    return Column(
      children: [
        ActionChip(
          backgroundColor: productProvider.isWeighed
              ? Colors.greenAccent
              : Colors.grey.shade400,
          label: Text(
            'Pruducto pesable',
            style: TextStyle(
              color: productProvider.isWeighed
                  ? Colors.black87
                  : Colors.grey.shade600,
            ),
          ),
          avatar: productProvider.isWeighed
              ? Icon(Icons.check, color: Colors.green)
              : null,
          onPressed: () => productProvider.changeIsWeighed(),
        ),
      ],
    );
  }
}
