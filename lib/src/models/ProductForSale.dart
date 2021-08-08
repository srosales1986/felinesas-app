import 'package:chicken_sales_control/src/models/Product_model.dart';

class ProductForSale {
  String productName = '';
  num price = 0;
  num amount = 0;
  num subTotal = 0;

  ProductForSale(Product product, int amount) {
    this.productName = product.name;
    this.price = product.priceByUnit;
    this.amount = amount;
    this.subTotal = this.price * this.amount;
  }
}
