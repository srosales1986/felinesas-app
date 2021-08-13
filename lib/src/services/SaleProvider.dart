import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:flutter/material.dart';

class SaleProvider extends ChangeNotifier {
  late List<Map<String, ProductForSale>> saleProductList;
  late DateTime startDateTime;
  late DateTime endDateTime;

  SaleProvider() {
    this.saleProductList = [];
    this.startDateTime = DateTime.now();
  }

  void addAmount(Customer actualCustomer, Product product) {
    if (this.saleProductList.any((e) => e.containsKey(product.id))) {
      this
          .saleProductList
          .firstWhere((e) => e.containsKey(product.id))
          .values
          .first
          .increaseAmout();
      notifyListeners();
    } else {
      this
          .saleProductList
          .add({product.id: ProductForSale(actualCustomer, product, 1)});
      notifyListeners();
    }
  }

  void subtractAmount(Product product) {
    var _isInProductList =
        this.saleProductList.any((e) => e.containsKey(product.id));

    if (!_isInProductList) {
      return;
    }

    var _actualAmount = this
        .saleProductList
        .firstWhere((e) => e.containsKey(product.id))
        .values
        .first
        .amount;

    if (_isInProductList && _actualAmount == 1) {
      var _indexOfProduct = this.saleProductList.indexOf(
          saleProductList.firstWhere((e) => e.containsKey(product.id)));
      this.saleProductList.removeAt(_indexOfProduct);

      return notifyListeners();
    }

    if (_isInProductList && _actualAmount != 0) {
      this
          .saleProductList
          .firstWhere((e) => e.containsKey(product.id))
          .values
          .first
          .decreaseAmout();
      return notifyListeners();
    }
  }

  num getTotal() {
    if (this.saleProductList.isEmpty) {
      return 0;
    }
    num total = 0;
    this.saleProductList.forEach((map) {
      total += map.values.first.subTotal;
    });
    return total;
  }
}
