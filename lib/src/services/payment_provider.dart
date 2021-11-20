import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/models/payment_model.dart';
import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  late Payment _currentPayment;

  void createPayment(Customer currentCustomer, UserModel currentUser) {
    this._currentPayment = Payment(
        customerId: currentCustomer.id,
        customerName: currentCustomer.name,
        dateCreated: DateTime.now(),
        newBalance: 0,
        previousBalance: currentCustomer.balance,
        userId: currentUser.id!,
        userName: currentUser.userName,
        paymentAmount: 0,
        methodOfPayment: 'UNKNOWN');
  }

  Payment get getCurrentPayment => this._currentPayment;
}
