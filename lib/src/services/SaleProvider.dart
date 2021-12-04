import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/models/Sale_model.dart';
import 'package:flutter/material.dart';

class SaleProvider extends ChangeNotifier {
  late Customer currentCustomer;
  late List<Map<String, ProductForSale>> saleProductList;

  late DateTime startDateTime;
  late DateTime endDateTime;
  num increment = 1;
  late num calculatedTotal;
  late num newBalance;
  late num cashInstallment;
  late num mpInstallment;
  late num finalInstallment;
  late num discount;
  late num finalTotal;

  Sale currentSale = Sale();

  void clearCurrentSale() {
    this.currentSale.balanceAfterSale = 0;
    this.currentSale.balanceBeforeSale = 0;
    this.currentSale.customerId = '';
    this.currentSale.cashInstallment = 0;
    this.currentSale.customerName = '';
    this.currentSale.discount = 0;
    this.currentSale.mpInstallment = 0;
    this.currentSale.productsList = [];
    this.currentSale.subtotal = 0;
    this.currentSale.total = 0;
  }
  // late AnimationController _amountAnimationController;

  SaleProvider() {
    this.saleProductList = [];
    this.startDateTime = DateTime.now();
    this.increment = 1.0;
    this.calculatedTotal = 0;
    this.newBalance = 0;
    this.cashInstallment = 0;
    this.mpInstallment = 0;
    this.finalInstallment = 0;
    this.discount = 0;
    this.finalTotal = 0;
  }

  // AnimationController get amountAnimationController =>
  //     this._amountAnimationController;

  // set amountAnimationController(AnimationController controller) {
  //   this._amountAnimationController = controller;
  //   // notifyListeners();
  // }
  void changeIncrement() {
    if (this.increment == 0.5) {
      this.increment = 1;
      notifyListeners();
    } else {
      this.increment = 0.5;
      notifyListeners();
    }
  }

  void clearInstallments() {
    this.cashInstallment = 0;
    this.mpInstallment = 0;
    this.discount = 0;
  }

  void clear() {
    this.saleProductList.clear();
    this.increment = 1.0;
    this.calculatedTotal = 0;
    this.newBalance = 0;
    this.cashInstallment = 0;
    this.mpInstallment = 0;
    this.finalInstallment = 0;
    this.discount = 0;
    this.finalTotal = 0;
    notifyListeners();
  }

  void clearSaleValues() {
    this.calculatedTotal = 0;
    this.newBalance = 0;
    this.cashInstallment = 0;
    this.mpInstallment = 0;
    this.finalInstallment = 0;
    this.discount = 0;
    this.finalTotal = 0;
  }

  void addAmount(Product product) {
    if (this.saleProductList.any((e) => e.containsKey(product.id))) {
      if (product.availabilityInDeposit ==
          this
              .saleProductList
              .firstWhere((e) => e.containsKey(product.id))
              .values
              .first
              .amount) {
        return;
      }
      this
          .saleProductList
          .firstWhere((e) => e.containsKey(product.id))
          .values
          .first
          .increaseAmout(this.increment);
      notifyListeners();
    } else {
      this
          .saleProductList
          .add({product.id: ProductForSale(product, this.increment)});
      notifyListeners();
    }
  }

  void subtractAmount(Product product) {
    var _isInProductList =
        this.saleProductList.any((e) => e.containsKey(product.id));

    if (!_isInProductList) {
      return;
    }

    var _currentAmount = this
        .saleProductList
        .firstWhere((e) => e.containsKey(product.id))
        .values
        .first
        .amount;

    if (_isInProductList && _currentAmount == 1) {
      var _indexOfProduct = this.saleProductList.indexOf(
          saleProductList.firstWhere((e) => e.containsKey(product.id)));
      this.saleProductList.removeAt(_indexOfProduct);

      return notifyListeners();
    }

    if (_isInProductList && _currentAmount != 0) {
      this
          .saleProductList
          .firstWhere((e) => e.containsKey(product.id))
          .values
          .first
          .decreaseAmout(this.increment);
      return notifyListeners();
    }
  }

  num getSubTotal() {
    if (this.saleProductList.isEmpty) {
      return 0;
    }
    num total = 0;
    this.saleProductList.forEach((map) {
      total += map.values.first.subtotal;
    });
    return total;
  }

  void updateCashInstallment(num cash) {
    this.cashInstallment = cash;
    notifyListeners();
  }

  void updateMpInstallment(num mpInstallment) {
    this.mpInstallment = mpInstallment;
    notifyListeners();
  }

  void updateDicount(num discount) {
    this.discount = discount;
    notifyListeners();
  }

  void updateNewBalance() {
    this.newBalance = (this.getSubTotal() + this.currentCustomer.balance) -
        (this.cashInstallment + this.mpInstallment + this.discount);
  }
}
