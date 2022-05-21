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
    final TextStyle _titleFontSize = TextStyle(fontSize: 14);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Productos Vendidos',
              style: _titleFontSize,
            ),
            Text(
              Utils.formatDateWithoutHms(reportProvider.selectedDate),
              style: _titleFontSize,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: TotalByProductTableSymmary(productsMap: productsMap)),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottonAction(context, Icons.home),
          ],
        ),
      ),
    );
  }

  Widget _bottonAction(BuildContext context, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Icon(
          icon,
          size: 30.0,
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, 'delivery_boy_home_page');
        },
      ),
    );
  }
}
