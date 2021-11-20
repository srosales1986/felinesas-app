import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/routes/routes.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeMainPage extends StatelessWidget {
  const HomeMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    fillPoviders() async {
      final firebaseProvider =
          Provider.of<FirebaseProvider>(context, listen: false);

      var _db = firebaseProvider.fbInstance;

      var productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);

      var customerProvider =
          Provider.of<CustomerProvider>(context, listen: false);

      Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts =
          _db.collection('products').get();

      getAllProducts.then((value) => productsProvider.fillProductList(
          value.docs.map((e) => Product.fromJson(e.id, e.data())).toList()));

      List<Product> productList = [];

      getAllProducts.then((value) {
        productList =
            value.docs.map((e) => Product.fromJson(e.id, e.data())).toList();
        productsProvider.productList = productList;
      });

      Future<QuerySnapshot<Map<String, dynamic>>> getAllCustomers =
          _db.collection('customers').get();

      List<Customer> customerList = [];
      getAllCustomers.then((value) {
        customerList =
            value.docs.map((e) => Customer.fromJson(e.id, e.data())).toList();
        customerProvider.customerList = customerList;
      });

      return 'OK';
    }

    return FutureBuilder(
      future: fillPoviders(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('ERROR'),
          );
        }
        if (snapshot.hasData) {
          return Home();
        }
        return Container(
          color: Color.fromARGB(255, 78, 131, 180),
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
      ],
      title: 'Venta de Pollo',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routes: getApplicationRoutes(),
      initialRoute: 'delivery_boy_home_page',
      // initialRoute: 'pdf_page',
    );
  }
}
