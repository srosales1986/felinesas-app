import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:chicken_sales_control/src/custom_widgets/confirmation_dialog.dart';
import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/payment_model.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:chicken_sales_control/src/services/payment_provider.dart';
import 'package:chicken_sales_control/src/services/sales_sheets_api.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Customer currentCustomer =
        ModalRoute.of(context)!.settings.arguments as Customer;

    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    paymentProvider.createPayment(currentCustomer, userProvider.currentUser);

    final Payment currentPayment = paymentProvider.getCurrentPayment;

    // print('${currentCustomer.balance}');
    // print('${currentPayment.paymentAmount}');

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text('Registrar pago'),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              child: buildBody(context, currentCustomer, currentPayment),
            ),
          ),
        ));
  }

  Column buildBody(
      BuildContext context, Customer currentCustomer, Payment currentPayment) {
    // final paymentProvider =
    //     Provider.of<PaymentProvider>(context, listen: false);

    final fbProvider = Provider.of<FirebaseProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        BounceInUp(
          duration: Duration(milliseconds: 300),
          child: Text(
            '${currentCustomer.name}',
            style: TextStyle(
              fontSize: 35,
              fontFamily: GoogleFonts.dancingScript().fontFamily,
              color: Colors.blue,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black38,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 5),
        BounceInUp(
          duration: Duration(milliseconds: 300),
          child: Text(
            'Saldo: \$${currentCustomer.balance}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 5),
        Divider(),
        SizedBox(
          height: 10,
        ),
        FadeInLeft(
          duration: Duration(milliseconds: 300),
          child: Text(
            'Ingese el monto',
            style: TextStyle(fontSize: 22),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$',
                style: TextStyle(fontSize: 50),
              ),
              Expanded(child: AmountText()),
            ],
          ),
        ),
        SizedBox(height: 10),
        BuildToggleButtons(currentPayment: currentPayment),
        SizedBox(height: 40),
        TextButton(
          style: ButtonStyle(
            enableFeedback: true,
            overlayColor: MaterialStateProperty.all(Colors.blue),
            fixedSize: MaterialStateProperty.all(Size(double.maxFinite, 60)),
            // elevation: MaterialStateProperty.all(4),
            shape: MaterialStateProperty.all(ContinuousRectangleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.green.shade300),
          ),
          onPressed: () {
            if (currentPayment.paymentAmount != 0) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return BounceInUp(
                    duration: Duration(milliseconds: 200),
                    child: ConfirmationDialog(
                      title: 'Registrar Pago',
                      contentText:
                          '¿Descontar \$ ${currentPayment.paymentAmount.toStringAsFixed(2)} a ${currentPayment.customerName}?',
                      yesFunction: () => saveNewBalance(
                        context,
                        currentPayment,
                        fbProvider,
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: Text(
            'GUARDAR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class BuildToggleButtons extends StatefulWidget {
  final Payment currentPayment;
  const BuildToggleButtons({
    Key? key,
    required this.currentPayment,
  }) : super(key: key);

  @override
  State<BuildToggleButtons> createState() => _BuildToggleButtonsState();
}

class _BuildToggleButtonsState extends State<BuildToggleButtons> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = isSelected.indexOf(true);
    if (selectedIndex == 0)
      widget.currentPayment.methodOfPayment = 'MercadoPago';
    else
      widget.currentPayment.methodOfPayment = 'Efectivo';
    return ToggleButtons(
      isSelected: isSelected,
      fillColor: Color.fromRGBO(0, 0, 255, 0.2),
      borderRadius: BorderRadius.circular(10),
      color: Colors.black,
      selectedColor: Colors.white,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            if (i == index) {
              isSelected[i] = true;
            } else {
              isSelected[i] = false;
            }
          }
          // if (selectedIndex == 0)
          //   widget.currentPayment.methodOfPayment = 'MercadoPago';
          // else
          //   widget.currentPayment.methodOfPayment = 'Efectivo';
        });
      },
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 12),
          child: Row(
            children: [
              Text('MercadoPago'),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(selectedIndex == 0 ? Icons.check : null,
                    color: Colors.greenAccent),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 12),
          child: Row(
            children: [
              Text('Efectivo'),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(selectedIndex == 1 ? Icons.check : null,
                    color: Colors.greenAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<dynamic> saveNewBalance(
  BuildContext context,
  Payment currentPayment,
  FirebaseProvider fbProvider,
) {
  Future<String> saveNewBalance() async {
    Future<String> getJson() {
      return rootBundle.loadString('android/gsheets-332502-a250b4fa3976.json');
    }

    try {
      final Map<String, dynamic> _credentials = json.decode(await getJson());
      // Map<String, dynamic> _credentials = configProvider.currentConfig.toJson();
      print(_credentials);

      await SalesSheetsApi.init(currentPayment.customerName, _credentials);
      currentPayment.newBalance =
          (currentPayment.previousBalance - currentPayment.paymentAmount);

      await fbProvider.fbCustomersCollectionRef
          .doc(currentPayment.customerId)
          .update({'balance': currentPayment.newBalance});

      final data = currentPayment.toJson(currentPayment);
      await FirebaseFirestore.instance.collection('payments').add(data);

      List<String> dataToSheet = [];
      dataToSheet.add('Pago');
      dataToSheet.add(currentPayment.userName);
      dataToSheet.add(Utils.formatDate(currentPayment.dateCreated));
      dataToSheet.add('-');
      dataToSheet.add('-');
      dataToSheet.add(currentPayment.previousBalance.toStringAsFixed(2));
      dataToSheet.add('-');
      if (currentPayment.methodOfPayment == 'Efectivo') {
        dataToSheet.add(currentPayment.paymentAmount.toStringAsFixed(2));
      } else {
        dataToSheet.add('-');
      }
      if (currentPayment.methodOfPayment == 'MercadoPago') {
        dataToSheet.add(currentPayment.paymentAmount.toStringAsFixed(2));
      } else {
        dataToSheet.add('-');
      }
      dataToSheet.add('-');
      dataToSheet.add(currentPayment.newBalance.toStringAsFixed(2));
      SalesSheetsApi.newRow(dataToSheet);
      return 'OK';
    } catch (e) {
      return e.toString();
    }
  }

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ElasticIn(
        duration: Duration(milliseconds: 200),
        child: Center(
          child: AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            content: FutureBuilder(
              future: saveNewBalance(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        SizedBox(height: 10.0),
                        Text('Esperando concexión...'),
                      ],
                    );
                  case ConnectionState.active:
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        SizedBox(height: 10.0),
                        Text('Guardando...'),
                      ],
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(snapshot.error.toString()),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Pago registrado',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElasticIn(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                          Container(
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade300),
                                fixedSize:
                                    MaterialStateProperty.all(Size(250, 60)),
                              ),
                              onPressed: () async {
                                Navigator.pushReplacementNamed(
                                    context, 'delivery_boy_home_page');
                              },
                              child: Container(
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class AmountText extends StatefulWidget {
  const AmountText({
    Key? key,
  }) : super(key: key);

  @override
  State<AmountText> createState() => _AmountTextState();
}

class _AmountTextState extends State<AmountText>
    with SingleTickerProviderStateMixin {
  final _paymentController = TextEditingController();
  late AnimationController _textAnimatedController;
  @override
  void initState() {
    super.initState();
    _textAnimatedController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    this._paymentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    return ElasticIn(
      duration: Duration(milliseconds: 200),
      controller: (controller) => _textAnimatedController = controller,
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        controller: _paymentController,
        smartDashesType: SmartDashesType.enabled,
        smartQuotesType: SmartQuotesType.enabled,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^(\d{0,4})\.?\d{0,2}')),
        ],
        onChanged: (value) {
          if (value == '.' || value == '0') {
            _paymentController.clear();
          } else {
            _textAnimatedController.forward(from: 0);
            if (_paymentController.text == '') {
              paymentProvider.getCurrentPayment.paymentAmount = 0;
            } else {
              paymentProvider.getCurrentPayment.paymentAmount =
                  double.parse(_paymentController.text);
            }
            setState(() {});
          }
        },
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 60),
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '0.00',
        ),
        showCursor: false,
      ),
    );
  }
}
