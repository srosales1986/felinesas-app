import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';

class TotalByProductTableSymmary extends StatelessWidget {
  final Map productsMap;
  const TotalByProductTableSymmary({Key? key, required this.productsMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: DataTable(
        columnSpacing: 15,
        horizontalMargin: 15,
        columns: [
          DataColumn(
            label: Text('Producto'),
          ),
          DataColumn(
            label: Align(
              child: Text('Precio'),
              alignment: Alignment.centerRight,
            ),
          ),
          DataColumn(
            label: Center(child: Text('Cantidad')),
          ),
          DataColumn(
            label: Center(child: Text('Total')),
          ),
        ],
        rows: buildRows(productsMap),
      ),
    );
  }

  List<DataRow> buildRows(Map productsMap) {
    List<DataRow> rowList = [];
    productsMap.forEach((key, value) {
      String productInitials = value['initials'];
      num price = value['price'];
      num amount = value['amount'];
      num total = value['subtotal'];
      rowList.add(DataRow(
        cells: [
          DataCell(Text(productInitials)),
          DataCell(Align(
            child: Text(Utils.formatCurrency(price)),
            alignment: Alignment.centerLeft,
          )),
          DataCell(Center(child: Text(amount.toString()))),
          DataCell(Align(
            child: Text(Utils.formatCurrency(total)),
            alignment: Alignment.centerLeft,
          )),
        ],
      ));
    });
    // .forEach((e) {
    //   rowList.add(DataRow(
    //     cells: [
    //       DataCell(Text(e.productName)),
    //       DataCell(Align(
    //         child: Text('\$' + e.price.toStringAsFixed(2)),
    //         alignment: Alignment.centerLeft,
    //       )),
    //       DataCell(Center(child: Text(e.amount.toString()))),
    //       DataCell(Align(
    //         child: Text('\$' + e.subtotal.toStringAsFixed(2)),
    //         alignment: Alignment.centerLeft,
    //       )),
    //     ],
    //   ));
    // });
    return rowList;
  }
}
