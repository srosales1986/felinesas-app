import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesDataFetch implements SalesRepository {
  final CollectionReference<Map<String, dynamic>> _fbSalesCollectionRef =
      FirebaseFirestore.instance.collection('sales');

  @override
  List<SaleToReport> getSalesListByUserAndDate(
      String externalUserId, DateTime date) {
    List<SaleToReport> salesList = [];

    _fbSalesCollectionRef
        .where('date_created',
            isGreaterThanOrEqualTo:
                DateTime.utc(date.year, date.month, date.day))
        .where('date_created',
            isLessThan: DateTime.utc(date.year, date.month, date.day + 1))
        .where('user_seller.external_id', isEqualTo: externalUserId)
        //.orderBy('date_created', descending: true)
        .get()
        .then((result) {
      for (var sale in result.docs) {
        salesList.add(SaleToReport.fromJson(sale.data()));
      }
    }).whenComplete(() => salesList.forEach((e) {
              print('${e.dateCreated} ${e.customerName}');
            }));
    return salesList;
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamSalesListByUserAndDate(
      String externalUserId, DateTime date) {
    return _fbSalesCollectionRef
        .where('date_created',
            isGreaterThanOrEqualTo:
                DateTime.utc(date.year, date.month, date.day))
        .where('date_created',
            isLessThan: DateTime.utc(date.year, date.month, date.day + 1))
        .where('user_seller.external_id', isEqualTo: externalUserId)
        .snapshots();
  }
}
