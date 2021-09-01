import 'package:chicken_sales_control/src/custom_widgets/MainButtonWidget.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class DeliveryBoyHomePage extends StatefulWidget {
  const DeliveryBoyHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryBoyHomePageState createState() => _DeliveryBoyHomePageState();
}

class _DeliveryBoyHomePageState extends State<DeliveryBoyHomePage> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: _onWillPopAction,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${userProvider.currentUser.userName}'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElasticInDown(
                      child: MainButtonWidget(
                        width: 150,
                        height: 150,
                        cardText: 'Nueva venta',
                        route: 'sales_page',
                        icon: Icons.receipt,
                      ),
                    ),
                    ElasticInDown(
                      child: MainButtonWidget(
                        width: 150,
                        height: 150,
                        cardText: 'Lista de precios',
                        route: 'price_list_page',
                        icon: Icons.request_quote,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElasticInUp(
                      child: MainButtonWidget(
                          width: 150,
                          height: 150,
                          cardText: 'Carga',
                          route: 'load_page',
                          icon: Icons.local_shipping),
                    ),
                    ElasticInUp(
                      child: MainButtonWidget(
                          width: 150,
                          height: 150,
                          cardText: 'Descarga',
                          route: 'unload_truck_page',
                          icon: Icons.assignment_return),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPopAction() async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Salir'),
                content: Text('¿Desea salir de la aplicación?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('Si'),
                  ),
                  TextButton(
                    onPressed: () => exit(0),
                    child: Text('No'),
                  ),
                ],
              );
            }) ??
        false;
  }
}
