import 'dart:io';

import '../../models/SaleToReport.dart';
import '../../models/User_model.dart';

abstract class ReportsUsesCases {
  void generateSalesByUserReportPdf(
      List<SaleToReport> salesList,
      num totalCashInstallment,
      num totalMpInstallment,
      UserModel currentUser,
      DateTime selectedDate);
}
