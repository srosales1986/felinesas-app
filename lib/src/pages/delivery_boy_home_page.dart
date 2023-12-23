import 'package:chicken_sales_control/src/custom_widgets/MainCardButton.dart';
import 'package:chicken_sales_control/src/pages/main_menu/CurrentAccountAmountWidget.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import 'main_menu/ActionButton.dart';
import 'main_menu/ExpandableFab.dart';

class DeliveryBoyHomePage extends StatefulWidget {
  const DeliveryBoyHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryBoyHomePageState createState() => _DeliveryBoyHomePageState();
}

class _DeliveryBoyHomePageState extends State<DeliveryBoyHomePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    bool _isAdmin = userProvider.currentUser.rol == 'ADMIN';

    // SalesSheetsApi.init(userProvider.currentUser.userName);
    return WillPopScope(
      onWillPop: _onWillPopAction,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('${userProvider.currentUser.userName}'),
        ),
        // drawer: _isAdmin ? _buildDrawer() : null,
        body: SafeArea(
          child: Stack(
            children: [
              Visibility(
                visible: _isAdmin,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(150, 30)),
                  child: Container(
                    color: Colors.blue,
                    height: 45,
                  ),
                ),
              ),
              Visibility(
                visible: _isAdmin,
                child: CurrentAccountAmountWidget(),
              ),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 5,
                  spacing: 5,
                  children: [
                    ElasticInDown(
                      child: MainCardButton(
                        cardText: 'Nueva venta',
                        icon: Icons.receipt,
                        route: 'new_sale_page',
                      ),
                    ),
                    ElasticInDown(
                      child: MainCardButton(
                        cardText: 'Lista de precios',
                        route: 'products_price_list_page',
                        icon: Icons.request_quote,
                        isAdmin: false,
                      ),
                    ),
                    ElasticInUp(
                      child: MainCardButton(
                        cardText: 'Registrar Pago',
                        route: 'customer_payment_page',
                        icon: Icons.paid_sharp,
                      ),
                    ),
                    _isAdmin
                        ? ElasticInUp(
                            child: MainCardButton(
                              cardText: 'Ventas del día',
                              route: 'sales_user_list_page',
                              icon: Icons.list,
                            ),
                          )
                        : ElasticInUp(
                            child: MainCardButton(
                              cardText: 'Nuevo cliente',
                              route: 'new_customer_page',
                              icon: Icons.add_business,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: _isAdmin
            ? ExpandableFab(
                distance: 100.0,
                children: [
                  ActionButton(
                    onPressed: () => Navigator.pushNamed(
                        context, 'products_price_list_page',
                        arguments: _isAdmin),
                    buttonText: 'Productos',
                    icon:
                        Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  ),
                  ActionButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, 'customer_page'),
                    buttonText: 'Clientes',
                    icon: Icon(Icons.account_box_rounded, color: Colors.white),
                  ),
                ],
              )
            : null,
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
}
