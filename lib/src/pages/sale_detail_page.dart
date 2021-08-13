import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);
    List<ProductForSale> productList = [];
    saleProvider.saleProductList.forEach((e) {
      productList.add(e.values.first);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la venta'),
      ),
      body: Container(
        child: Column(
          children: [
            DataTable(
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
              rows: getRows(productList),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Align(
                child: Text(
                    'TOTAL: \$' + saleProvider.getTotal().toStringAsFixed(2)),
                alignment: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> getRows(List<ProductForSale> productList) {
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
            child: Text('\$' + e.subTotal.toStringAsFixed(2)),
            alignment: Alignment.centerLeft,
          )),
        ],
      ));
    });
    return rowList;
  }
}
