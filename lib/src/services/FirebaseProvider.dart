import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore _fbInstance = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _fbCustomersCollectionRef =
      FirebaseFirestore.instance.collection('customers');
  final CollectionReference<Map<String, dynamic>> _fbProductsCollectionRef =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference<Map<String, dynamic>> _fbUsersCollectionRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference<Map<String, dynamic>> _fbSalesCollectionRef =
      FirebaseFirestore.instance.collection('sales');
  final CollectionReference<Map<String, dynamic>> _fbConfigCollectionRef =
      FirebaseFirestore.instance.collection('config');

  FirebaseFirestore get fbInstance => this._fbInstance;
  CollectionReference<Map<String, dynamic>> get fbCustomersCollectionRef =>
      this._fbCustomersCollectionRef;
  CollectionReference<Map<String, dynamic>> get fbProductsCollectionRef =>
      this._fbProductsCollectionRef;
  CollectionReference<Map<String, dynamic>> get fbUsersCollectionRef =>
      this._fbUsersCollectionRef;
  CollectionReference<Map<String, dynamic>> get fbSalesCollectionRef =>
      this._fbSalesCollectionRef;
  CollectionReference<Map<String, dynamic>> get fbConfigCollectionRef =>
      this._fbConfigCollectionRef;
}
