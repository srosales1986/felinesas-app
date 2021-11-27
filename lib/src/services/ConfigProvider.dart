import 'package:chicken_sales_control/src/models/gsheet/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  final Future<QuerySnapshot<Map<String, dynamic>>> _configRef =
      FirebaseFirestore.instance.collection('config').get();

  late Config _currentConfig;

  void setCurrentConfig(Map<String, dynamic> config) {
    this._currentConfig = Config.fromJson(config);
  }

  Config get currentConfig => this._currentConfig;

  Future<String> getSpreadSheetId() async {
    String _spreadsheetId = '';
    try {
      await _configRef.then((value) {
        _spreadsheetId = value.docs
            .map((e) => Config.fromJson(e.data()).spreadsheetId)
            .single;
      });
    } on Exception catch (e) {
      print(e);
    }
    if (_spreadsheetId == '') {
      return 'Error';
    }
    return _spreadsheetId;
  }

  get configRef => this._configRef;
}
