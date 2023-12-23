import 'package:chicken_sales_control/src/models/ProductForSale.dart';

class ProductForSaleList {
  List<ProductForSale> productList;

  ProductForSaleList({required this.productList});

  factory ProductForSaleList.fromJson(List<dynamic> json) {
    List<ProductForSale> productList = [];
    productList = json.map((e) => ProductForSale.fromJson(e)).toList();
    return ProductForSaleList(productList: productList);
  }
}
