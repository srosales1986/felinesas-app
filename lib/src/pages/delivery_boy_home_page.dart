import 'package:chicken_sales_control/src/custom_widgets/MainButtonWidget.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
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
        drawer: _buildDrawer(),
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
                    onPressed: () => exit(0),
                    child: Text('Si'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                ],
              );
            }) ??
        false;
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menu-img.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.account_box_rounded),
            title: Text('Clientes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'customer_page');
            },
          ),
        ],
      ),
    );
  }
}
