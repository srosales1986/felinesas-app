import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/ReportProvider.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesByUserPage extends StatefulWidget {
  SalesByUserPage({Key? key}) : super(key: key);

  @override
  _SalesByUserPageState createState() => _SalesByUserPageState();
}

class _SalesByUserPageState extends State<SalesByUserPage> {
  @override
  void initState() {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    final _dbProvider = Provider.of<FirebaseProvider>(context, listen: false);

    final _salesCollection = _dbProvider.fbSalesCollectionRef;

    _salesCollection.snapshots().listen((event) {
      List<SaleToReport> saleList =
          event.docs.map((e) => SaleToReport.fromJson(e.data())).toList();
      reportProvider.salesList = saleList;
      // setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    Map<String, String> _selectedUser =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    List<SaleToReport> _salesList = [];

    reportProvider.salesList.forEach((sale) {
      if (sale.userSeller.externalId == _selectedUser['userId'] &&
          sale.dateCreated.day == DateTime.now().day) {
        _salesList.add(sale);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas de: ${_selectedUser['userName']}'),
      ),
      body: _salesList.isEmpty
          ? Center(
              child: Text('No hay ventas hoy'),
            )
          : ListView.builder(
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
                      subtitle: Text('Fecha: ' +
                          Utils.formatDate(_salesList[index].dateCreated)),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
    );
  }
}
