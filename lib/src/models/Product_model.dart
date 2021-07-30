class Product {
  String initials;
  String name;
  num priceByKg;
  num priceByUnit;
  num availabilityInDeposit;

  Product(
      {required this.initials,
      required this.name,
      required this.priceByKg,
      required this.priceByUnit,
      required this.availabilityInDeposit});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      initials: json['initials'],
      name: json['name'],
      priceByKg: json['price_by_kg'],
      priceByUnit: json['price_by_unit'],
      availabilityInDeposit: json['availability_in_deposit'],
    );
  }
}
