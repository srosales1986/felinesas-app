import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:flutter/cupertino.dart';

class ReportProvider extends ChangeNotifier {
  List<SaleToReport> salesList = [];
  DateTime selectedDate = DateTime.now();

  void setSelectedDate(DateTime date) {
    this.selectedDate = date;
    ChangeNotifier();
  }
}
