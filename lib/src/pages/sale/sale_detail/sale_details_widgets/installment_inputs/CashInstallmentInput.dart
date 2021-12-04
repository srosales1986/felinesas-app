import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CashInstallmentInput extends StatefulWidget {
  const CashInstallmentInput({Key? key}) : super(key: key);

  @override
  State<CashInstallmentInput> createState() => _CashInstallmentInputState();
}

class _CashInstallmentInputState extends State<CashInstallmentInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Entrega en efectivo \$ ',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 50.0,
            width: 100.0,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              textAlign: TextAlign.center,
              controller: _controller,
              onTap: () => _controller.text == '0' ? _controller.clear() : null,
              onChanged: (value) {
                if (value == '.' || value == '0') {
                  _controller.clear();
                } else {
                  setState(() {
                    if (value != '') {
                      saleProvider.updateCashInstallment(double.parse(value));
                      saleProvider.updateNewBalance();
                    } else {
                      saleProvider.updateCashInstallment(0);
                      saleProvider.updateNewBalance();
                    }
                  });
                }
              },
              decoration: InputDecoration(
                label: Text('Monto'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
