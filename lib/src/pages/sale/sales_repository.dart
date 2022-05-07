import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SalesRepository {
  List<SaleToReport> getSalesListByUserAndDate(
      String externalUserId, DateTime date);

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamSalesListByUserAndDate(
      String externalUserId, DateTime date);
}
