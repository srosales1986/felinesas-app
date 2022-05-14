import 'package:chicken_sales_control/src/pages/reports/TotalByProductTableSummary.dart';
import 'package:chicken_sales_control/src/services/ReportProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SoldProductsTablePage extends StatelessWidget {
  final Map productsMap;
  const SoldProductsTablePage({Key? key, required this.productsMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Productos Vendidos'),
            Text(Utils.formatDateWithoutHms(reportProvider.selectedDate)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: TotalByProductTableSymmary(productsMap: productsMap)),
    );
  }
}
