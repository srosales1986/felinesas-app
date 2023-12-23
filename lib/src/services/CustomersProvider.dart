import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/pages/customer/CustomerRepository.dart';
import 'package:chicken_sales_control/src/pages/customer/search/CustomerRepositoryImpl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProvider extends ChangeNotifier {
  List<Customer> _customerList = [];
  final CustomerRepository customerRepository = CustomerRepositoryImpl();
  num currentAccountAmount = 0;

  void fillCustomerList(List<Customer> customer) {
    this._customerList.addAll(customer);
    // notifyListeners();
  }

  set customerList(List<Customer> customerList) {
    this._customerList = customerList;
    notifyListeners();
  }

  void addCustomer(Customer newCustomer) {
    this._customerList.add(newCustomer);
    // notifyListeners();
  }

  List<Customer> get customerList => this._customerList;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCustomerStream() =>
      customerRepository.getCustomerStream();

  set setCurrentAccountAmount(num newAmount) {
    this.currentAccountAmount = newAmount;
    notifyListeners();
  }

  num get getCurrentAccountAmount => this.currentAccountAmount;
}
