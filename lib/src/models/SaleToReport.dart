import 'package:chicken_sales_control/src/models/User_model.dart';

class SaleToReport {
  late String customerId;
  late String customerName;
  late String dateCreated;
  late String discount;
  late String cashInstallment;
  late String mpInstallment;
  late String subtotal;
  late UserModel userSeller;
  // late String balanceBeforeSale;
  // late String balanceAfterSale;

  SaleToReport({
    required this.customerId,
    required this.customerName,
    required this.dateCreated,
    required this.discount,
    required this.cashInstallment,
    required this.mpInstallment,
    required this.subtotal,
    required this.userSeller,
    // required this.balanceBeforeSale,
    // required this.balanceAfterSale,
  });

  factory SaleToReport.fromJson(Map<String, dynamic> map) {
    return SaleToReport(
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      dateCreated: map['date_created'].toString(),
      discount: map['discount'].toString(),
      cashInstallment: map['cash_installment'].toString(),
      mpInstallment: map['mp_installment'].toString(),
      subtotal: map['subtotal'].toString(),
      userSeller: UserModel.fromJson(
          map['user_seller']['external_id'], map['user_seller']),
      // balanceBeforeSale: map['balance_beforeSale'].toString(),
      // balanceAfterSale: map['balance_afterSale'].toString(),
    );
  }
}
