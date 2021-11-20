import 'package:chicken_sales_control/src/pages/customer_page.dart';
import 'package:chicken_sales_control/src/pages/load_page.dart';
import 'package:chicken_sales_control/src/pages/add_products_page.dart';
import 'package:chicken_sales_control/src/pages/delivery_boy_home_page.dart';
// import 'package:chicken_sales_control/src/pages/login_page.dart';
import 'package:chicken_sales_control/src/pages/login_page.dart';
import 'package:chicken_sales_control/src/pages/new_customer_page.dart';
import 'package:chicken_sales_control/src/pages/new_product_page.dart';
import 'package:chicken_sales_control/src/pages/customer_payment_page.dart';
import 'package:chicken_sales_control/src/pages/payment_page.dart';
import 'package:chicken_sales_control/src/pages/products_price_list.dart';
import 'package:chicken_sales_control/src/pages/sale_detail/sale_detail_and_finish_sale_page.dart';
import 'package:chicken_sales_control/src/pages/new_sale_page.dart';
import 'package:chicken_sales_control/src/pages/sales_page.dart';
import 'package:chicken_sales_control/src/pages/unload_truck_page.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'login_page': (BuildContext context) => LoginPage(),
    'new_sale_page': (BuildContext context) => NewSalePage(),
    'delivery_boy_home_page': (BuildContext context) => DeliveryBoyHomePage(),
    'add_products_page': (BuildContext context) => AddProductsPage(),
    'load_page': (BuildContext context) => LoadPage(),
    'products_price_list_page': (BuildContext context) => ProductPriceList(),
    'new_product_page': (BuildContext context) => NewProductPage(),
    'unload_truck_page': (BuildContext context) => UnloadTruckPage(),
    'customer_page': (BuildContext context) => CustomerPage(),
    'new_customer_page': (BuildContext context) => NewCustomerPage(),
    'sale_detail_and_finish_sale_page': (BuildContext context) =>
        SaleDetailAndFinishPage(),
    'customer_payment_page': (BuildContext context) => CustomerPaymentPage(),
    'payment_page': (BuildContext context) => PaymentPage(),
    'sales_page': (BuildContext context) => SalesPage(),
  };
}
