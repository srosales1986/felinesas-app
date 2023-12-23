import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/models/ProductForSaleList.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';

class SaleToReport {
  late String customerId;
  late String customerName;
  late DateTime dateCreated;
  late String discount;
  late num cashInstallment;
  late num mpInstallment;
  late String subtotal;
  late UserModel userSeller;
  late List<ProductForSale> productsList;
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
    required this.productsList,
    // required this.balanceBeforeSale,
    // required this.balanceAfterSale,
  });

  factory SaleToReport.fromJson(Map<String, dynamic> map) {
    return SaleToReport(
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      dateCreated: DateTime.fromMillisecondsSinceEpoch(
          map['date_created'].millisecondsSinceEpoch),
      discount: map['discount'].toString(),
      cashInstallment: map['cash_installment'],
      mpInstallment: map['mp_installment'],
      subtotal: map['subtotal'].toString(),
      userSeller: UserModel.fromJson(
          map['user_seller']['external_id'], map['user_seller']),
      productsList:
          ProductForSaleList.fromJson(map['products_list'] as List).productList,
    );
  }
}
