import 'package:chicken_sales_control/src/models/Product_model.dart';

class ProductForSale {
  String productId = '';
  String productName = '';
  String productInitials = '';
  num price = 0.0;
  num amount = 0.0;
  num subtotal = 0.0;
  num finalAmount = 0.0;

  ProductForSale(Product product, num amount) {
    this.productId = product.id;
    this.productName = product.name;
    this.productInitials = product.initials;
    this.price = product.priceByUnit;
    this.amount = amount;
    this.subtotal = this.price * this.amount;
    this.finalAmount = product.availabilityInDeposit - 1.0;
  }

  void increaseAmout(num increment) {
    this.amount += increment;
    this.subtotal = this.price * this.amount;
    this.finalAmount -= increment;
  }

  void decreaseAmout(num increment) {
    this.amount -= increment;
    this.subtotal = this.price * this.amount;
    this.finalAmount += increment;
  }

  Map<String, dynamic> toMap(ProductForSale productForSale) {
    return {
      'product_id': productForSale.productId,
      'product_name': productForSale.productName,
      'product_initials': productForSale.productInitials,
      'price': productForSale.price,
      'amount': productForSale.amount,
      'finalAmount': productForSale.finalAmount,
      'subtotal': productForSale.subtotal
    };
  }
}
