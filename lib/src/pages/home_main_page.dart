import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/routes/routes.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class HomeMainPage extends StatelessWidget {
  const HomeMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _db = FirebaseFirestore.instance;

    Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts =
        _db.collection('products').get();

    Future<QuerySnapshot<Map<String, dynamic>>> getAllCustomers =
        _db.collection('customers').get();

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getAllProducts,
      builder: (context, snapshot) {
        var productsProvider =
            Provider.of<ProductsProvider>(context, listen: false);

        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }
        if (!snapshot.hasData) {
          Center(
            child: Image(
              image: AssetImage('assets/images/init_chicken.gif'),
            ),
          );
        }
        if (snapshot.hasData && productsProvider.productList.isEmpty) {
          productsProvider.fillProductList(snapshot.data!.docs
              .map((e) => Product.fromJson(e.id, e.data()))
              .toList());

          print(productsProvider.productList.length);

          return getCustomerFromFirebase(getAllCustomers);
        }

        if (productsProvider.productList.isNotEmpty) {
          return Home();
        }

        return Container(
          color: Color.fromARGB(255, 78, 131, 180),
          child: Center(
            child: Image(
              image: AssetImage('assets/images/init_chicken.gif'),
            ),
          ),
        );
      },
    );
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> getCustomerFromFirebase(
      Future<QuerySnapshot<Map<String, dynamic>>> getAllCustomers) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getAllCustomers,
        builder: (context, snapshot) {
          var customerProvider =
              Provider.of<CustomerProvider>(context, listen: false);
          if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          }
          if (!snapshot.hasData) {
            Center(
              child: Image(
                image: AssetImage('assets/images/init_chicken.gif'),
              ),
            );
          }
          if (snapshot.hasData && customerProvider.customerList.isEmpty) {
            customerProvider.fillCustomerList(snapshot.data!.docs
                .map((e) => Customer.fromJson(e.id, e.data()))
                .toList());

            print(customerProvider.customerList.length);
            return Home();
          }
          return Container(
            color: Color.fromARGB(255, 78, 131, 180),
            child: Center(
              child: Image(
                image: AssetImage('assets/images/init_chicken.gif'),
              ),
            ),
          );
        });
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
        primarySwatch: Colors.blue,
      ),
      routes: getApplicationRoutes(),
      // initialRoute: 'delivery_boy_home_page',
      initialRoute: 'login_page',
    );
  }
}
