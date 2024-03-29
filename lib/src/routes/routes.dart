import 'package:chicken_sales_control/src/pages/customer/customer_page.dart';
import 'package:chicken_sales_control/src/pages/sale/add_products/add_products_page_v2.dart';
import 'package:chicken_sales_control/src/pages/delivery_boy_home_page.dart';
import 'package:chicken_sales_control/src/pages/login_page.dart';
import 'package:chicken_sales_control/src/pages/customer/new_customer_page.dart';
import 'package:chicken_sales_control/src/pages/product/new_product_page.dart';
import 'package:chicken_sales_control/src/pages/payment/customer_payment_page.dart';
import 'package:chicken_sales_control/src/pages/payment/payment_page.dart';
import 'package:chicken_sales_control/src/pages/product/products_price_list.dart';
import 'package:chicken_sales_control/src/pages/sale/new_sale_page.dart';
import 'package:chicken_sales_control/src/pages/sale/sale_detail/SaleDetails.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_by_user_page.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_user_list.dart';
import 'package:chicken_sales_control/src/pages/unload_truck_page.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'login_page': (BuildContext context) => LoginPage(),
    'new_sale_page': (BuildContext context) => NewSalePage(),
    'delivery_boy_home_page': (BuildContext context) => DeliveryBoyHomePage(),
    'add_products_page': (BuildContext context) => AddProductsPage2(),
    'products_price_list_page': (BuildContext context) => ProductPriceList(),
    'new_product_page': (BuildContext context) => NewProductPage(),
    'unload_truck_page': (BuildContext context) => UnloadTruckPage(),
    'customer_page': (BuildContext context) => CustomerPage(),
    'new_customer_page': (BuildContext context) => NewCustomerPage(),
    'sale_details': (BuildContext context) => SaleDetails(),
    'customer_payment_page': (BuildContext context) => CustomerPaymentPage(),
    'payment_page': (BuildContext context) => PaymentPage(),
    'sales_user_list_page': (BuildContext context) => SalesUserList(),
    'sales_by_user_page': (BuildContext context) => SalesByUserPage(),
  };
}
