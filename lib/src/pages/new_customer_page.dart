import 'package:chicken_sales_control/src/models/Customer_model.dart';
// import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewCustomerPage extends StatelessWidget {
  const NewCustomerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Customer? currentCustomer =
        ModalRoute.of(context)!.settings.arguments as Customer?;
    bool isANewCustomer = currentCustomer == null;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: isANewCustomer ? Text('Nuevo cliente') : Text('Editar cliente'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          elevation: 10,
          child: Column(
            children: [
              ElasticIn(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: isANewCustomer
                      ? Icon(
                          Icons.add_business,
                          size: 50,
                          color: Colors.orange.shade400,
                        )
                      : Icon(
                          Icons.edit,
                          size: 50,
                          color: Colors.orange.shade400,
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: NewCustomerForm(
                  isANewCustomer: isANewCustomer,
                  editingCustomer: currentCustomer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewCustomerForm extends StatefulWidget {
  final bool isANewCustomer;
  final Customer? editingCustomer;
  const NewCustomerForm({
    Key? key,
    required this.isANewCustomer,
    required this.editingCustomer,
  }) : super(key: key);

  @override
  _NewCustomerFormState createState() => _NewCustomerFormState();
}

class _NewCustomerFormState extends State<NewCustomerForm> {
  final _cuitTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _balance = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _cuitTextController.dispose();
    _nameTextController.dispose();
    _addressTextController.dispose();
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      'Consumidor final',
      'Monotributista',
      'Responsable inscripto'
    ];

    String dropDownValue = items[0];

    if (!widget.isANewCustomer) {
      _cuitTextController.text = widget.editingCustomer!.cuit;
      _nameTextController.text = widget.editingCustomer!.name;
      _addressTextController.text = widget.editingCustomer!.address;
      _balance.text = widget.editingCustomer!.balance.toStringAsFixed(2);
      dropDownValue = widget.editingCustomer!.ivaCond;
    }

    final firebaseProvider =
        Provider.of<FirebaseProvider>(context, listen: false);
    // final customerProvider =
    //     Provider.of<CustomerProvider>(context, listen: false);
    final TextStyle _textStyle = TextStyle(fontSize: 15);

    double _spaceBewtweenTextfield = 15.0;

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
              ],
              style: _textStyle,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              controller: _cuitTextController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'CUIT',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: _spaceBewtweenTextfield,
            ),
            TextFormField(
              enableSuggestions: false,
              style: _textStyle,
              controller: _nameTextController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: _spaceBewtweenTextfield,
            ),
            TextFormField(
              enableSuggestions: false,
              style: _textStyle,
              controller: _addressTextController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: _spaceBewtweenTextfield,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              style: _textStyle,
              textAlign: TextAlign.center,
              controller: _balance,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Saldo',
                prefix: Text('\$'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onEditingComplete: () {},
            ),
            SizedBox(
              height: _spaceBewtweenTextfield,
            ),
            DropdownButtonFormField(
                value: dropDownValue,
                items: items.map(buildDropDownMenuItems).toList(),
                onChanged: (value) => setState(() {
                      if (widget.isANewCustomer) {
                        dropDownValue = value.toString();
                        // FocusScope.of(context).nextFocus();
                      } else {
                        widget.editingCustomer!.ivaCond = value.toString();
                        // FocusScope.of(context).nextFocus();
                      }
                    })),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BounceInLeft(
                  duration: Duration(milliseconds: 200),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 40),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'customer_page');
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                BounceInRight(
                  duration: Duration(milliseconds: 200),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 40),
                      ),
                    ),
                    onPressed: () {
                      Customer newCustomer = Customer(
                        id: widget.isANewCustomer
                            ? ''
                            : widget.editingCustomer!.id,
                        cuit: _cuitTextController.text.trim(),
                        name: _nameTextController.text.trim(),
                        address: _addressTextController.text.trim(),
                        ivaCond: dropDownValue.trim(),
                        status: 'ACT',
                        balance: double.parse(_balance.text.trim()),
                      );
                      if (widget.isANewCustomer) {
                        firebaseProvider.fbInstance
                            .collection('customers')
                            .doc()
                            .set(newCustomer.toMap(newCustomer));
                        // customerProvider.addCustomer(newCustomer);
                      } else {
                        firebaseProvider.fbInstance
                            .collection('customers')
                            .doc(newCustomer.id)
                            .update(newCustomer.toMap(newCustomer));
                      }

                      Navigator.pushReplacementNamed(context, 'customer_page');
                    },
                    child: Text(
                      'Guardar',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildDropDownMenuItems(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item),
      alignment: Alignment.center,
    );
  }
}
