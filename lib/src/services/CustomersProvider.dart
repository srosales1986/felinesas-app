import 'package:chicken_sales_control/src/models/Customer_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProvider extends ChangeNotifier {
  // CollectionReference<Map<String, dynamic>> _customerCollection =
  //     FirebaseFirestore.instance.collection('customer');
  List<Customer> _customerList = [];

  void fillCustomerList(List<Customer> customer) {
    this._customerList.addAll(customer);
    // notifyListeners();
  }

  set customerList(List<Customer> customerList) {
    this._customerList = customerList;
    notifyListeners();
  }
  // void fetchCustomer() {
  //   _customerCollection.snapshots().listen((event) {
  //     fillCustomerList(
  //         event.docs.map((e) => Customer.fromJson(e.id, e.data())).toList());
  //   });
  // }

  void addCustomer(Customer newCustomer) {
    this._customerList.add(newCustomer);
    // notifyListeners();
  }

  List<Customer> get customerList => this._customerList;
}
