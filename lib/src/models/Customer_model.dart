class Customer {
  String cuit;
  String name;
  String address;
  String condIva;

  Customer({
    required this.cuit,
    required this.name,
    required this.address,
    required this.condIva,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        cuit: json['id'].toString(),
        name: json['name'],
        address: json['address']['street'],
        condIva: json['address']['zipcode']);
  }
}
