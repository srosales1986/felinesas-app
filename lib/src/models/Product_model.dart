class Product {
  String id;
  String initials;
  String name;
  num priceByKg;
  num priceByUnit;
  num availabilityInDeposit;
  bool isWeighed;

  Product({
    required this.id,
    required this.initials,
    required this.name,
    required this.priceByKg,
    required this.priceByUnit,
    required this.availabilityInDeposit,
    required this.isWeighed,
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      initials: json['initials'],
      name: json['name'],
      priceByKg: json['price_by_kg'],
      priceByUnit: json['price_by_unit'],
      availabilityInDeposit: json['availability_in_deposit'],
      isWeighed: json['is_weighed'],
    );
  }

  Map<String, dynamic> toMap(Product newProduct) {
    return {
      'initials': newProduct.initials,
      'name': newProduct.name,
      'price_by_kg': newProduct.priceByKg,
      'price_by_unit': newProduct.priceByUnit,
      'availability_in_deposit': newProduct.availabilityInDeposit,
      'is_weighed': newProduct.isWeighed,
    };
  }
}
