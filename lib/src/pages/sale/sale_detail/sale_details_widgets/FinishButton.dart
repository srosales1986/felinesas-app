import 'package:chicken_sales_control/src/models/ProductForSale.dart';
import 'package:chicken_sales_control/src/pages/sale/sale_detail/sale_details_widgets/FinishSaleConfirmDialog.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:chicken_sales_control/src/services/SaleService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinishButton extends StatelessWidget {
  const FinishButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    List<ProductForSale> productList = [];

    saleProvider.saleProductList.forEach((e) {
      productList.add(e.values.first);
    });
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              color: Colors.green.shade500,
              child: TextButton(
                child: Text(
                  'Finalizar venta',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => FinishSaleConfirmDialog(
                    title: 'Finalizar venta',
                    contentText: '¿Cerrar la venta definitivamente?',
                    yesFunction: () => SaleService.showCloseSaleDialog(
                      context,
                      saleProvider.currentCustomer,
                      productList,
                      saleProvider.calculatedTotal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
