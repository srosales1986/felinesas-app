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
    this.price = product.isWeighed ? product.priceByKg : product.priceByUnit;
    this.amount = amount;
    this.subtotal = this.price * this.amount;
    this.finalAmount = product.availabilityInDeposit - amount;
    // this.finalAmount = product.isWeighed
    //     ? product.availabilityInDeposit - amount
    // : product.availabilityInDeposit - 1.0; //TODO: Y si se vende 0.5????
  }

  ProductForSale.report({
    required this.productId,
    required this.productName,
    required this.productInitials,
    required this.price,
    required this.amount,
    required this.subtotal,
    required this.finalAmount,
  });

  void increaseAmout(num increment) {
    this.amount += increment;
    this.subtotal = this.price * this.amount;
    this.finalAmount -= increment;
  }

  void increaseWeight(num weight) {
    this.subtotal = this.price * this.amount;
  }

  void updateWeighedAmount(num weight, num stock) {
    this.amount = weight;
    this.increaseWeight(weight);
    this.finalAmount = stock - weight;
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

  factory ProductForSale.fromJson(Map<String, dynamic> json) {
    return ProductForSale.report(
        productId: json['product_id'],
        productName: json['product_name'],
        productInitials: json['product_initials'],
        price: json['price'],
        amount: json['amount'],
        subtotal: json['subtotal'],
        finalAmount: json['finalAmount']);
  }
}
