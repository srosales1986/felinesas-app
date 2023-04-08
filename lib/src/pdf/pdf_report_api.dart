import 'dart:io';

import 'package:chicken_sales_control/src/pdf/pdf_api.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../models/SaleToReport.dart';
import '../models/User_model.dart';

class PdfReportApi {
  static Future<File> generate(
      List<SaleToReport> salesList,
      UserModel currentUser,
      DateTime selectedDate,
      num totalCashInstallment,
      num totalMpInstallment) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        // buildHeader(invoice),
        buildTitle(currentUser, selectedDate),
        // buildInvoice(invoice),
        Divider(),
        buildBody(salesList),
      ],
      // footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Reporte_de_ventas.pdf', pdf: pdf);
  }

  static Widget buildTitle(UserModel currentUser, DateTime selectedDate) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${currentUser.userName}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            'Fecha: ${Utils.formatDateWithoutHms(selectedDate)}',
            style: TextStyle(fontSize: 18),
          ),
        ],
      );

  static Widget buildBody(List<SaleToReport> salesList) {
    final headers = [
      'Cliente',
      'Efectivo',
      'MercadoPago',
      'Total',
    ];
    final data = salesList.reversed.map((item) {
      // final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.customerName,
        '\$ ${item.cashInstallment.toStringAsFixed(2)}',
        '${item.mpInstallment.toStringAsFixed(2)}',
        '\$ ${(item.cashInstallment + item.mpInstallment).toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.centerRight,
      },
    );
  }
}
