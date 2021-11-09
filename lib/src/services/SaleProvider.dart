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
  late num increment;
  late num calculatedTotal;
  late num newBalance;
  late num cashInstallment;
  late num mpInstallment;
  late num finalInstallment;
  late num discount;
  late num finalTotal;

  final Sale currentSale = Sale();
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

  void clear() {
    this.saleProductList.clear();
    notifyListeners();
  }

  void addAmount(Product product) {
    if (this.saleProductList.any((e) => e.containsKey(product.id))) {
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
}
