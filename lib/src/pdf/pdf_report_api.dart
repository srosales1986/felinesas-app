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
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      build: (context) => [
        // buildHeader(invoice),
        buildTitle(currentUser, selectedDate),
        // buildInvoice(invoice),
        Divider(),
        buildBody(salesList),
        Divider(),
        buildTotal(totalCashInstallment, totalMpInstallment)
      ],
      // footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Reporte_de_ventas.pdf', pdf: pdf);
  }

  static Widget buildTitle(UserModel currentUser, DateTime selectedDate) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${currentUser.userName}',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            'Fecha: ${Utils.formatDateWithoutHms(selectedDate)}',
            style: TextStyle(fontSize: 18),
          ),
        ],
      );

  static Widget buildBody(List<SaleToReport> salesList) {
    final headers = [
      'Hora',
      'Cliente',
      'Efectivo',
      'MercadoPago',
      'Total',
    ];
    final data = salesList.reversed.map((item) {
      // final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        Utils.formatDateOnlyHms(item.dateCreated),
        item.customerName,
        '${Utils.formatCurrency(item.cashInstallment)}',
        '${Utils.formatCurrency(item.mpInstallment)}',
        '${Utils.formatCurrency((item.cashInstallment + item.mpInstallment))}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 20,
      oddRowDecoration: BoxDecoration(color: PdfColors.grey200),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
      },
    );
  }

  static Widget buildTotal(num totalCashInstallment, num totalMpInstallment) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total efectivo:',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '${Utils.formatCurrency(totalCashInstallment)}',
                  unite: true,
                ),
                buildText(
                  title: 'Total MercadoPago:',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '${Utils.formatCurrency(totalMpInstallment)}',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
