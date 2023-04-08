import 'dart:io';

import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/pages/reports/reports_uses_cases.dart';
import 'package:chicken_sales_control/src/pdf/pdf_api.dart';
import 'package:chicken_sales_control/src/pdf/pdf_report_api.dart';

class ReportsUsesCasesImp implements ReportsUsesCases {
  @override
  void generateSalesByUserReportPdf(
      List<SaleToReport> salesList,
      num totalCashInstallment,
      num totalMpInstallment,
      UserModel currentUser,
      DateTime selectedDate) {
    File pdfFile;

    PdfReportApi.generate(salesList, currentUser, selectedDate,
            totalCashInstallment, totalMpInstallment)
        .then((value) {
      pdfFile = value;
      PdfApi.openFile(pdfFile);
    });

    // salesList.reversed.forEach((saleReport) {
    //   print(
    //       '${saleReport.dateCreated} - ${saleReport.customerName} - ${saleReport.mpInstallment}');
    //   print(totalMpInstallment);
    // });
  }
}
