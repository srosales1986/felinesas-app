class Customer {
  String id;
  String cuit;
  String name;
  String address;
  String ivaCond;
  num debt;

  Customer(
      {required this.id,
      required this.cuit,
      required this.name,
      required this.address,
      required this.ivaCond,
      required this.debt});

  factory Customer.fromJson(String id, Map<String, dynamic> json) {
    return Customer(
        id: id,
        cuit: json['cuit'].toString(),
        name: json['name'],
        address: json['address'],
        ivaCond: json['iva_cond'],
        debt: json['debt']);
  }
}
