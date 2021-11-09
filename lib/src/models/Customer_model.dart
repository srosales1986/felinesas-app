class Customer {
  String id;
  String cuit;
  String name;
  String address;
  String ivaCond;
  String status;
  num balance;

  Customer(
      {required this.id,
      required this.cuit,
      required this.name,
      required this.address,
      required this.ivaCond,
      required this.status,
      required this.balance});

  factory Customer.fromJson(String id, Map<String, dynamic> json) {
    return Customer(
        id: id,
        cuit: json['cuit'].toString(),
        name: json['name'],
        address: json['address'],
        ivaCond: json['iva_cond'],
        status: json['status'],
        balance: json['balance']);
  }

  Map<String, dynamic> toMap(Customer newCustomer) {
    return {
      'cuit': newCustomer.cuit,
      'name': newCustomer.name,
      'address': newCustomer.address,
      'iva_cond': newCustomer.ivaCond,
      'status': 'ACT',
      'balance': newCustomer.balance
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
        balance: 0);
  }
}
