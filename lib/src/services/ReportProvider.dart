import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:flutter/cupertino.dart';

class ReportProvider extends ChangeNotifier {
  List<SaleToReport> salesList = [];
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

  void setSelectedDate(DateTime date) {
    this.selectedDate = date;
    ChangeNotifier();
  }
}
