import 'package:chicken_sales_control/src/pages/home_main_page.dart';
import 'package:chicken_sales_control/src/pages/reports/expansion_panel_provider.dart';
import 'package:chicken_sales_control/src/services/ConfigProvider.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:chicken_sales_control/src/services/ReportProvider.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:chicken_sales_control/src/services/payment_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ProductsProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CustomerProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SaleProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => FirebaseProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PaymentProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ConfigProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ReportProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ExpansionPanelProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Icon(Icons.error);
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            print('ConnectionState.done');

            return HomeMainPage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Container(
            color: Colors.blue,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        });
  }
}
