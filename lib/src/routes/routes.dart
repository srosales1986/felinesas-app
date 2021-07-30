import 'package:chicken_sales_control/src/pages/load_page.dart';
import 'package:chicken_sales_control/src/pages/add_products_page.dart';
import 'package:chicken_sales_control/src/pages/delivery_boy_home_page.dart';
import 'package:chicken_sales_control/src/pages/price_list_page.dart';
import 'package:chicken_sales_control/src/pages/sales_page.dart';
import 'package:chicken_sales_control/src/pages/unload_truck_page.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'sales_page': (BuildContext context) => SalesPage(),
    'delivery_boy_home_page': (BuildContext context) => DeliveryBoyHomePage(),
    'add_products_page': (BuildContext context) => AddProductsPage(),
    'load_page': (BuildContext context) => LoadPage(),
    'price_list_page': (BuildContext context) => PriceListPage(),
    'unload_truck_page': (BuildContext context) => UnloadTruckPage(),
  };
}
