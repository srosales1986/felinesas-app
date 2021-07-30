import 'dart:convert';

import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  static Future<List<Customer>> fetchCustomer() async {
    final String url = 'https://jsonplaceholder.typicode.com/users';
    final response = await http.get(Uri.parse(url));
    print('Fetching done');
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((customer) => Customer.fromJson(customer))
          .toList();
    } else {
      throw Exception('Error al cargar los clientes');
    }
  }
}
