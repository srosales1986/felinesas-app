import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:flutter/material.dart';

class SaleProvider extends ChangeNotifier {
  late List<Map<String, int>> saleProductList;
  late List<ProductForSale> productForSaleList;
  late DateTime startSaleDate;
  late DateTime endSaleDate;

  SaleProvider() {
    this.saleProductList = [];
    this.productForSaleList = [];
    this.startSaleDate = DateTime.now();
    this.endSaleDate = DateTime.now();
  }

  void addAmount2(Product product) {
    if (this.saleProductList.any((e) => e.containsKey(product.id))) {
      this
          .saleProductList
          .firstWhere((e) => e.containsKey(product.id))
          .update(product.id, (value) => value + 1);
      notifyListeners();
    } else {
      this.saleProductList.add({product.id: 1});
      notifyListeners();
    }
  }

  void addAmount(Product product) {}

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
        .first;

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
          .update(product.id, (value) => value - 1);
      return notifyListeners();
    }
  }
}
