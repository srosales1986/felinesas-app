import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/ReportProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildSalesByUser extends StatefulWidget {
  BuildSalesByUser({Key? key}) : super(key: key);

  @override
  _BuildSalesByUserState createState() => _BuildSalesByUserState();
}

class _BuildSalesByUserState extends State<BuildSalesByUser> {
  @override
  void initState() {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    final _dbProvider = Provider.of<FirebaseProvider>(context, listen: false);

    final _salesCollection = _dbProvider.fbSalesCollectionRef;

    _salesCollection.snapshots().listen((event) {
      List<SaleToReport> saleList =
          event.docs.map((e) => SaleToReport.fromJson(e.data())).toList();
      reportProvider.salesList = saleList;
      setState(() {});
    });

    // _salesCollection.snapshots().listen((event) {
    //   List<SaleToReport> saleList = event.docs.where((element) => element.data()['date_created'] == DateTime.now().day);
    //   reportProvider.salesList = saleList;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    // saleProvider.currentCustomer =
    //     ModalRoute.of(context)!.settings.arguments as Customer;
    String _selectedUserId =
        ModalRoute.of(context)!.settings.arguments as String;

    List<SaleToReport> _salesList = [];

    // reportProvider.salesList.map((sale) {
    //   if (sale.userSeller.id == _selectedUserId) {
    //     _salesList.add(sale);
    //   }
    // });
    reportProvider.salesList.forEach((sale) {
      if (sale.userSeller.externalId == _selectedUserId) {
        _salesList.add(sale);
      }
    });

    if (_salesList.isEmpty) {
      return Center(
        child: Text('No hay ventas hoy'),
      );
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _salesList.length,
      itemBuilder: (context, index) {
        if (_salesList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            ListTile(
              title: Text('Cliente: ${_salesList[index].customerName}'),
              subtitle: Text('Fecha: ${_salesList[index].dateCreated}'),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
