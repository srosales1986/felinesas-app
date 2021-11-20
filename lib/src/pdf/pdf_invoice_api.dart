import 'dart:io';

import 'package:chicken_sales_control/src/models/invoice_model.dart';
import 'package:chicken_sales_control/src/pdf/pdf_api.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      // footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  // static Widget buildHeader(Invoice invoice) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 1 * PdfPageFormat.cm),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             buildSupplierAddress(invoice.seller),
  //             Container(
  //               height: 50,
  //               width: 50,
  //               child: BarcodeWidget(
  //                 barcode: Barcode.qrCode(),
  //                 data: invoice.info.number,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 1 * PdfPageFormat.cm),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             buildCustomerAddress(invoice.customer),
  //             buildInvoiceInfo(invoice.info),
  //           ],
  //         ),
  //       ],
  //     );

  // static Widget buildCustomerAddress(Customer customer) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //         Text(customer.address),
  //       ],
  //     );

  // static Widget buildInvoiceInfo(InvoiceInfo info) {
  //   final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
  //   final titles = <String>[
  //     'Invoice Number:',
  //     'Invoice Date:',
  //     'Payment Terms:',
  //     'Due Date:'
  //   ];
  //   final data = <String>[
  //     info.number,
  //     Utils.formatDate(info.date),
  //     paymentTerms,
  //     Utils.formatDate(info.dueDate),
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: List.generate(titles.length, (index) {
  //       final title = titles[index];
  //       final value = data[index];

  //       return buildText(title: title, value: value, width: 200);
  //     }),
  //   );
  // }

  // static Widget buildSupplierAddress(Supplier supplier) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         Text(supplier.address),
  //       ],
  //     );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESUMEN DE VENTA',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            'Fecha: ${Utils.formatDate(invoice.info.date)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Text(
            'Cliente: ${invoice.info.customerName}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Text(
            'Vendedor: ${invoice.info.sellerName}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Producto',
      'Precio',
      'Cantidad',
      'Total',
    ];
    final data = invoice.items.map((item) {
      // final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.productName,
        '\$ ${item.unitPrice}',
        '${item.quantity}',
        '\$ ${item.total.toStringAsFixed(2)}',
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

  static Widget buildTotal(Invoice invoice) {
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
                  title: 'Subtotal:',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '\$${invoice.info.subtotal.toStringAsFixed(2)}',
                  unite: true,
                ),
                buildText(
                  title: 'Saldo anterior:',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '\$${invoice.info.beforeBalance.toStringAsFixed(2)}',
                  unite: true,
                ),
                buildText(
                  title: 'Total:',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '\$${invoice.info.total.toStringAsFixed(2)}',
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Entrega en efectivo:',
                  value: '\$${invoice.info.cashIstallment.toStringAsFixed(2)}',
                  unite: true,
                ),
                buildText(
                  title: 'MercadoPago:',
                  value: '\$${invoice.info.mpInstallment.toStringAsFixed(2)}',
                  unite: true,
                ),
                buildText(
                  title: 'Descuento:',
                  value: '-\$${invoice.info.discount.toStringAsFixed(2)}',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                buildText(
                  title: 'Saldo a la fecha:',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '\$${invoice.info.finalBalance.toStringAsFixed(2)}',
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

  // static Widget buildFooter(Invoice invoice) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Divider(),
  //         SizedBox(height: 2 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Address', value: invoice.info.),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
  //       ],
  //     );

  // static buildSimpleText({
  //   required String title,
  //   required String value,
  // }) {
  //   final style = TextStyle(fontWeight: FontWeight.bold);

  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: pw.CrossAxisAlignment.end,
  //     children: [
  //       Text(title, style: style),
  //       SizedBox(width: 2 * PdfPageFormat.mm),
  //       Text(value),
  //     ],
  //   );
  // }

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
