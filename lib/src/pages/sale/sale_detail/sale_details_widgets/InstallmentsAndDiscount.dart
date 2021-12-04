import 'package:flutter/material.dart';

import 'installment_inputs/CashInstallmentInput.dart';
import 'installment_inputs/DiscountInput.dart';
import 'installment_inputs/MPInstallmentInput.dart';

class InstallmentAndDiscount extends StatelessWidget {
  const InstallmentAndDiscount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CashInstallmentInput(),
          Divider(),
          MPInstallmentInput(),
          Divider(),
          DiscountInput(),
        ],
      ),
    );
  }
}
