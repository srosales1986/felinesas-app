import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SubtotalAndTotalCalculate extends StatefulWidget {
  final Customer currentCustomer;
  SubtotalAndTotalCalculate({
    Key? key,
    required this.currentCustomer,
  }) : super(key: key);

  @override
  _SubtotalAndTotalCalculateState createState() =>
      _SubtotalAndTotalCalculateState();
}

class _SubtotalAndTotalCalculateState extends State<SubtotalAndTotalCalculate> {
  final _cashInstallmentController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  final _mpInstallmentController = TextEditingController(text: '0');
  @override
  void dispose() {
    this._cashInstallmentController.dispose();
    this._discountController.dispose();
    this._mpInstallmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    final num _total =
        saleProvider.getSubTotal() + saleProvider.currentCustomer.balance;
    saleProvider.finalTotal = _total;

    num _installmentTotal =
        saleProvider.cashInstallment + saleProvider.mpInstallment;

    num _discount = saleProvider.discount;

    saleProvider.calculatedTotal = _total - _installmentTotal;

    if (_cashInstallmentController.text.trim() != '' &&
        _cashInstallmentController.text.trim() != '0') {
      if (_mpInstallmentController.text.trim() != '') {
        saleProvider.cashInstallment =
            double.parse(_cashInstallmentController.text.trim());
        saleProvider.mpInstallment =
            double.parse(_mpInstallmentController.text.trim());
        _installmentTotal =
            saleProvider.cashInstallment + saleProvider.mpInstallment;
      } else {
        saleProvider.cashInstallment =
            double.parse(_cashInstallmentController.text.trim());
        _installmentTotal = saleProvider.cashInstallment;
      }
      if (_discountController.text.trim() != '') {
        saleProvider.discount = double.parse(_discountController.text.trim());
        saleProvider.calculatedTotal -=
            (_installmentTotal + saleProvider.discount);
      } else {
        saleProvider.calculatedTotal -= _installmentTotal;
      }
    }
    if (_mpInstallmentController.text.trim() != '' &&
        _mpInstallmentController.text.trim() != '0') {
      saleProvider.mpInstallment =
          double.parse(_mpInstallmentController.text.trim());

      if (_cashInstallmentController.text.trim() != '') {
        saleProvider.cashInstallment =
            double.parse(_cashInstallmentController.text.trim());
        _installmentTotal =
            saleProvider.mpInstallment + saleProvider.cashInstallment;
      } else {
        _installmentTotal = saleProvider.mpInstallment;
      }

      if (_discountController.text.trim() != '') {
        saleProvider.discount = double.parse(_discountController.text.trim());
        saleProvider.calculatedTotal -=
            (_installmentTotal + saleProvider.discount);
      } else {
        saleProvider.calculatedTotal -= _installmentTotal;
      }
    }
    if (_discountController.text.trim() != '' &&
        _discountController.text.trim() != '0') {
      saleProvider.discount = double.parse(_discountController.text.trim());
      _discount = saleProvider.discount;
      saleProvider.calculatedTotal -= _discount;
    }
    saleProvider.newBalance = _total - (_installmentTotal + _discount);

    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 10, right: 20.0, bottom: 1.0),
            child: Text(
              'Subtotal: \$' + saleProvider.getSubTotal().toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 10, right: 20.0, bottom: 1.0),
            child: Text(
              'Saldo anterior: \$ ${saleProvider.currentCustomer.balance.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 10, right: 20.0, bottom: 1.0),
            child: Text(
              'TOTAL: \$ ${_total.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                color: Colors.grey,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 5.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  // 'TOTAL: \$ ${saleProvider.calculatedTotal.toStringAsFixed(2)}',
                  'SALDO ACTUAL: \$ ${saleProvider.newBalance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
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
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                        ],
                        textAlign: TextAlign.center,
                        controller: _cashInstallmentController,
                        onTap: () => _cashInstallmentController.text == '0'
                            ? _cashInstallmentController.clear()
                            : null,
                        onChanged: (value) {
                          if (value == '.' || value == '0') {
                            _cashInstallmentController.clear();
                          } else {
                            setState(() {});
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
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'MercadoPago \$ ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 50.0,
                      width: 100.0,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                        ],
                        textAlign: TextAlign.center,
                        controller: _mpInstallmentController,
                        onTap: () => _mpInstallmentController.text == '0'
                            ? _mpInstallmentController.clear()
                            : null,
                        onChanged: (value) {
                          if (value == '.' || value == '0') {
                            _mpInstallmentController.clear();
                          } else {
                            setState(() {});
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
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '\$ ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 50.0,
                      width: 100.0,
                      child: TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                        ],
                        onTap: () => _discountController.text == '0'
                            ? _discountController.clear()
                            : null,
                        onChanged: (value) {
                          if (value == '.' || value == '0') {
                            _discountController.clear();
                          } else {
                            setState(() {});
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          prefix: Text('-'),
                          label: Text('Descuento'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
