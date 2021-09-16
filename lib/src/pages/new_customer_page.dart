import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Nuevo cliente'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          elevation: 10,
          child: Column(
            children: [
              ElasticIn(
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Icon(
                    Icons.add_business,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: NewCustomerForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewCustomerForm extends StatefulWidget {
  const NewCustomerForm({
    Key? key,
  }) : super(key: key);

  @override
  _NewCustomerFormState createState() => _NewCustomerFormState();
}

class _NewCustomerFormState extends State<NewCustomerForm> {
  final _cuitTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _ivaTextController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _cuitTextController.dispose();
    _nameTextController.dispose();
    _addressTextController.dispose();
    _ivaTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseProvider =
        Provider.of<FirebaseProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    final TextStyle _textStyle = TextStyle(fontSize: 15);

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextFormField(
              style: _textStyle,
              textAlign: TextAlign.center,
              controller: _cuitTextController,
              keyboardType: TextInputType.number,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'CUIT',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
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
              height: 20,
            ),
            TextFormField(
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
              height: 20,
            ),
            TextFormField(
              style: _textStyle,
              controller: _ivaTextController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Iva Condicional',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
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
                        id: '',
                        cuit: _cuitTextController.text,
                        name: _nameTextController.text,
                        address: _addressTextController.text,
                        ivaCond: _ivaTextController.text,
                        status: 'ACT',
                        debt: 0,
                      );
                      firebaseProvider.fbInstance
                          .collection('customers')
                          .doc()
                          .set(newCustomer.toMap(newCustomer));
                      customerProvider.addCustomer(newCustomer);
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
}
