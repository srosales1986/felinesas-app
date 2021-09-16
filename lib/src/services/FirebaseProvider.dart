import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final _fbInstance = FirebaseFirestore.instance;

  FirebaseFirestore get fbInstance => this._fbInstance;
}
