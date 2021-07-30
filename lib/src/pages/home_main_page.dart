import 'package:chicken_sales_control/src/routes/routes.dart';
// import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:flutter/material.dart';

class HomeMainPage extends StatelessWidget {
  const HomeMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Venta de Pollo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: getApplicationRoutes(),
      initialRoute: 'delivery_boy_home_page',
    );
  }
}
