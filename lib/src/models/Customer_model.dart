class Customer {
  String id;
  String cuit;
  String name;
  String address;
  String ivaCond;
  String status;
  num debt;

  Customer(
      {required this.id,
      required this.cuit,
      required this.name,
      required this.address,
      required this.ivaCond,
      required this.status,
      required this.debt});

  factory Customer.fromJson(String id, Map<String, dynamic> json) {
    return Customer(
        id: id,
        cuit: json['cuit'].toString(),
        name: json['name'],
        address: json['address'],
        ivaCond: json['iva_cond'],
        status: json['status'],
        debt: json['debt']);
  }

  Map<String, dynamic> toMap(Customer newCustomer) {
    return {
      'cuit': newCustomer.cuit,
      'name': newCustomer.name,
      'address': newCustomer.address,
      'iva_cond': newCustomer.ivaCond,
      'status': 'ACT',
      'debt': 0
    };
  }

  factory Customer.empty() {
    return Customer(
        id: '',
        cuit: '',
        name: '',
        address: '',
        ivaCond: '',
        status: '',
        debt: 0);
  }
}
