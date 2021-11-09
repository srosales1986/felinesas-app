import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _productList = [];

  void fillProductList(List<Product> products) {
    this._productList.addAll(products);
    // notifyListeners();
  }

  List<Product> get productList => this._productList;

  set productList(List<Product> productList) {
    this._productList = productList;
    notifyListeners();
  }
}
