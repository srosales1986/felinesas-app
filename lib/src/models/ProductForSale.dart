import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';

class ProductForSale {
  String productName = '';
  num price = 0;
  num amount = 0;
  num subTotal = 0;
  String customerCuit = '';
  String customerName = '';
  String customerAddress = '';

  ProductForSale(Customer customer, Product product, int amount) {
    this.productName = product.name;
    this.price = product.priceByUnit;
    this.amount = amount;
    this.subTotal = this.price * this.amount;
    this.customerCuit = customer.cuit;
    this.customerName = customer.name;
    this.customerAddress = customer.address;
  }

  void increaseAmout() {
    this.amount++;
    this.subTotal = this.price * this.amount;
  }

  void decreaseAmout() {
    this.amount--;
    this.subTotal = this.price * this.amount;
  }
}
