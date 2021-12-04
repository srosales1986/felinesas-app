import 'package:chicken_sales_control/src/pages/sale/sale_detail/sale_details_widgets/FinishButton.dart';
import 'package:chicken_sales_control/src/pages/sale/sale_detail/sale_details_widgets/InstallmentsAndDiscount.dart';
import 'package:chicken_sales_control/src/pages/sale/sale_detail/sale_details_widgets/NewBalanceText.dart';
import 'package:chicken_sales_control/src/pages/sale/sale_detail/sale_details_widgets/SaleDetailDataTable.dart';
import 'package:chicken_sales_control/src/pages/sale/sale_detail/sale_details_widgets/SummaryOfTotals.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleDetails extends StatelessWidget {
  const SaleDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    saleProvider.currentSale.userSeller = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Detalle de la venta'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'add_products_page');
            saleProvider.clearInstallments();
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cliente: ${saleProvider.currentCustomer.name}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Divider(),
              SaleDetailDataTable(),
              Divider(),
              SummaryOfTotals(),
              NewBalanceText(),
              SizedBox(height: 10),
              InstallmentAndDiscount(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FinishButton(),
    );
  }
}
