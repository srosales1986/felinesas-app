import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:flutter/material.dart';

class CustomerProvider extends ChangeNotifier {
  List<Customer> _customerList = [];

  void fillCustomerList(List<Customer> customer) {
    this._customerList.addAll(customer);
    // notifyListeners();
  }

  List<Customer> get customerList => this._customerList;
}
