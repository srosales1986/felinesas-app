import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DiscountInput extends StatefulWidget {
  DiscountInput({Key? key}) : super(key: key);

  @override
  _DiscountInputState createState() => _DiscountInputState();
}

class _DiscountInputState extends State<DiscountInput> {
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
            'Descuento \$ ',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 50.0,
            width: 100.0,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              onTap: () => _controller.text == '0' ? _controller.clear() : null,
              onChanged: (value) {
                if (value == '.' || value == '0') {
                  _controller.clear();
                } else {
                  setState(
                    () {
                      if (value != '') {
                        saleProvider.updateDicount(double.parse(value));
                        saleProvider.updateNewBalance();
                      } else {
                        saleProvider.updateDicount(0);
                        saleProvider.updateNewBalance();
                      }
                    },
                  );
                }
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                prefix: Text('-'),
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
