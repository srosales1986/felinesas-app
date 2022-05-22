import 'package:chicken_sales_control/src/pages/customer/CustomerRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _fbCustomerCollectionRef =
      FirebaseFirestore.instance.collection('customers').snapshots();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getCustomerStream() =>
      this._fbCustomerCollectionRef;
}
