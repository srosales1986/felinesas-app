import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class Sale {
  String _customerId = '';
  DateTime _dateCreated = DateTime.now();
  DateTime _dateModified = DateTime.now();
  List<ProductForSale> _productsList = [];
  late UserModel _userSeller;
  String _status = 'SUCCESS';
  num _cashInstallment = 0.0;
  num _mpInstallment = 0.0;
  num _subtotal = 0.0;
  num _discount = 0.0;
  num _total = 0.0;
  num _balanceBeforeSale = 0.0;
  num _balanceAfterSale = 0.0;

  Sale();

  factory Sale.newSale(
    String customerId,
    List<ProductForSale> productsList,
    UserModel userSeller,
    num subtotal,
    num cashInstallment,
    num mpInstallment,
    num discount,
    num balanceBeforeSale,
    num balanceAfterSale,
  ) {
    final _newSale = Sale();

    _newSale._customerId = customerId;
    _newSale._dateCreated = DateTime.now();
    _newSale._discount = discount;
    _newSale._cashInstallment = cashInstallment;
    _newSale._mpInstallment = mpInstallment;
    _newSale._productsList = productsList;
    _newSale._subtotal = subtotal;
    _newSale._userSeller = userSeller;
    _newSale._balanceBeforeSale = balanceBeforeSale;
    _newSale._balanceAfterSale = balanceAfterSale;

    return _newSale;
  }

  Map<String, dynamic> toMap(Sale sale) {
    return {
      'customer_id': sale._customerId,
      'user_seller': sale._userSeller.toJson(sale._userSeller),
      'date_created': sale._dateCreated,
      'date_modified': sale._dateModified,
      'status': sale._status,
      'products_list': sale._productsList.map((e) => e.toMap(e)).toList(),
      'subtotal': sale._subtotal,
      'cash_installment': sale._cashInstallment,
      'mp_installment': sale._mpInstallment,
      'discount': sale._discount,
      'balance_before_sale': sale._balanceBeforeSale,
      'balance_after_sale': sale._balanceAfterSale,
      'total': sale._total
    };
  }

  set total(num total) => this._total = total;
  num get total => this._total;

  set status(String status) => this._status = status;
  String get status => this._status;

  set dateModified(DateTime dateModified) => this._dateModified = dateModified;
  DateTime get dateModified => this._dateModified;

  set dateCreated(DateTime dateCreated) => this._dateCreated = dateCreated;
  DateTime get dateCreated => this._dateCreated;

  set userSeller(UserModel userSeller) => this._userSeller = userSeller;
  UserModel get userSeller => this._userSeller;

  set cashInstallment(num cashInstallment) =>
      this._cashInstallment = cashInstallment;
  num get installment => this._cashInstallment;

  set mpInstallment(num mpInstallment) => this._mpInstallment = mpInstallment;
  num get mpInstallment => this._mpInstallment;

  set discount(num discount) => this._discount = discount;
  num get discount => this._discount;

  set subtotal(num subtotal) => this._subtotal = subtotal;
  num get subtotal => this._subtotal;

  set customerId(String customerId) => this._customerId = customerId;
  String get customerId => this._customerId;

  set balanceBeforeSale(num balanceBeforeSale) =>
      this._balanceBeforeSale = balanceBeforeSale;
  num get balanceBeforeSale => this._balanceBeforeSale;

  set balanceAfterSale(num balanceAfterSale) =>
      this._balanceAfterSale = balanceAfterSale;
  num get balanceAfterSale => this.balanceAfterSale;

  set productsList(List<ProductForSale> productsList) =>
      this._productsList = productsList;
  List<ProductForSale> get productsList => this._productsList;
}
