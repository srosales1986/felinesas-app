import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddWeightDialog extends StatefulWidget {
  final Product product;

  AddWeightDialog({Key? key, required this.product}) : super(key: key);

  @override
  _AddWeightDialogState createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<AddWeightDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: '0');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    if (saleProvider.saleProductList
        .any((e) => e.containsKey(widget.product.id))) {
      String text = saleProvider.saleProductList
          .firstWhere((e) => e.containsKey(widget.product.id))
          .values
          .first
          .amount
          .toStringAsFixed(2);

      return ActionChip(
        elevation: 3,
        labelPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 6),
        label: Text('$text Kg.'),
        onPressed: () => showWeightDialog(widget.product),
      );
    }

    return ActionChip(
      elevation: 3,
      labelPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 6),
      label: Text(
        'AGREGAR',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => showWeightDialog(widget.product),
    );
  }

  Future<dynamic> showWeightDialog(Product product) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: false);
    num price = product.priceByKg;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text('Ingrese el peso')),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                enableInteractiveSelection: false,
                onChanged: (value) {
                  if (_controller.text != '' && _controller.text != '0') {
                    saleProvider.updateWeightProductSubtotal(
                        price * double.parse(value));
                  } else {
                    saleProvider.updateWeightProductSubtotal(0);
                  }
                },
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d{1,2})\.?\d{0,2}$')),
                  LengthLimitingTextInputFormatter(4),
                ],
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  suffix: Text('Kg.'),
                ),
              ),
              SizedBox(height: 15),
              _controller.text == '' ? Text('0') : Subtotal(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.text = '0';
              Navigator.of(context).pop(false);
            },
            child: Text(
              'CANCELAR',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(
              onPressed: () {
                if (_controller.text != '' && _controller.text != '0') {
                  saleProvider.updateWeighedAmount(
                      widget.product, double.parse(_controller.text));
                } else {
                  saleProvider.deleteWeighedProduct(widget.product);
                }
                Navigator.of(context).pop(false);
              },
              child: Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}

class Subtotal extends StatefulWidget {
  const Subtotal({
    Key? key,
  }) : super(key: key);

  @override
  State<Subtotal> createState() => _SubtotalState();
}

class _SubtotalState extends State<Subtotal> {
  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    setState(() {});
    return Text(
        'Total: ${Utils.formatCurrency(saleProvider.weightProductSubtotal)}');
  }
}
