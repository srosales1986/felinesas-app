import 'package:chicken_sales_control/src/custom_widgets/MainButtonWidget.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

class DeliveryBoyHomePage extends StatefulWidget {
  const DeliveryBoyHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryBoyHomePageState createState() => _DeliveryBoyHomePageState();
}

class _DeliveryBoyHomePageState extends State<DeliveryBoyHomePage> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    bool _isAdmin = userProvider.currentUser.rol == 'ADMIN';

    // SalesSheetsApi.init(userProvider.currentUser.userName);
    return WillPopScope(
      onWillPop: _onWillPopAction,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('${userProvider.currentUser.userName}'),
        ),
        drawer: _isAdmin ? _buildDrawer() : null,
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
                        route: 'new_sale_page',
                        icon: Icons.receipt,
                      ),
                    ),
                    ElasticInDown(
                      child: MainButtonWidget(
                        width: 150,
                        height: 150,
                        cardText: 'Lista de precios',
                        route: 'products_price_list_page',
                        isAdmin: false,
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
                          cardText: 'Registrar Pago',
                          route: 'customer_payment_page',
                          icon: Icons.paid_sharp),
                    ),
                    ElasticInUp(
                      child: MainButtonWidget(
                          width: 150,
                          height: 150,
                          cardText: 'Ventas',
                          route: 'sales_page',
                          icon: Icons.list),
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
    final authService = FirebaseAuth.instance;
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Salir'),
                content: Text('¿Desea salir de la aplicación?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      authService.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'login_page', (route) => false);
                    },
                    // onPressed: () => exit(0),
                    child: Text('Si'),
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
          ListTile(
            leading: Icon(Icons.account_box_rounded),
            title: Text('Productos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'products_price_list_page',
                  arguments: true);
            },
          ),
        ],
      ),
    );
  }
}
