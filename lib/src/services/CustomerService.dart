import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:chicken_sales_control/src/models/Customer_model.dart';
// import 'package:http/http.dart' as http;

class CustomerService {
  // static Future<List<Customer>> fetchCustomer() async {
  //   final String url = 'https://jsonplaceholder.typicode.com/users';
  //   final response = await http.get(Uri.parse(url));
  //   print('Fetching done');
  //   if (response.statusCode == 200) {
  //     return (jsonDecode(response.body) as List)
  //         .map((customer) => Customer.fromJson(customer))
  //         .toList();
  //   } else {
  //     throw Exception('Error al cargar los clientes');
  //   }
  // }

  static getCustomerListTile(
      List<Customer> customerList, BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);
    List<Widget> customerListTile = [];
    customerList.forEach((customer) {
      customerListTile.add(Column(
        children: [
          ListTile(
            onTap: () {
              saleProvider.startDateTime = DateTime.now();
              Navigator.pushNamed(context, 'add_products_page',
                  arguments: customer);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            minVerticalPadding: 1,
            leading: Icon(
              Icons.account_circle,
              size: 60,
              color: Color(0xFFadcbff),
            ),
            title: Text(
              customer.name,
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(customer.address),
              ],
            ),
          ),
          Divider(),
        ],
      ));
    });
    return customerListTile;
  }
}
