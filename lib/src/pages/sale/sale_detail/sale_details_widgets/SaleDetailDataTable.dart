import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:flutter/material.dart';

class SaleDetailDataTable extends StatelessWidget {
  final List<ProductForSale> productList;

  const SaleDetailDataTable({
    Key? key,
    required this.productList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DataTable(
        columnSpacing: 15,
        horizontalMargin: 15,
        columns: [
          DataColumn(
            label: Text('Producto'),
          ),
          DataColumn(
            label: Center(child: Text('Precio')),
          ),
          DataColumn(
            label: Center(child: Text('Cantidad')),
          ),
          DataColumn(
            label: Align(
              child: Text('Total'),
              alignment: Alignment.centerRight,
            ),
          ),
        ],
        rows: buildRows(productList),
      ),
    );
  }

  List<DataRow> buildRows(List<ProductForSale> productList) {
    List<DataRow> rowList = [];
    productList.forEach((e) {
      rowList.add(DataRow(
        cells: [
          DataCell(Text(e.productName)),
          DataCell(Align(
            child: Text('\$' + e.price.toStringAsFixed(2)),
            alignment: Alignment.centerLeft,
          )),
          DataCell(Center(child: Text(e.amount.toString()))),
          DataCell(Align(
            child: Text('\$' + e.subtotal.toStringAsFixed(2)),
            alignment: Alignment.centerLeft,
          )),
        ],
      ));
    });
    return rowList;
  }
}
