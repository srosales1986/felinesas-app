import 'package:chicken_sales_control/src/models/SaleToReport.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesByUserListBuilder extends StatefulWidget {
  final UserModel currentUser;
  SalesByUserListBuilder({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _SalesByUserListBuilderState createState() => _SalesByUserListBuilderState();
}

class _SalesByUserListBuilderState extends State<SalesByUserListBuilder> {
  // @override
  // void initState() {
  //   final reportProvider = Provider.of<ReportProvider>(context, listen: false);

  //   final _dbProvider = Provider.of<FirebaseProvider>(context, listen: false);

  //   Stream<QuerySnapshot<Map<String, dynamic>>> _salesStream =
  //       _dbProvider.salesStream;

  //   reportProvider.salesList = _salesStream.listen((event) {
  //     event.docs.map((element) {
  //       _list = [];
  //       if (element.data()['user_seller'].external_id ==
  //           widget.currentUser.externalId) {
  //         return element.data();
  //       }
  //     }).toList();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final reportProvider = Provider.of<ReportProvider>(context, listen: true);
    final _dbProvider = Provider.of<FirebaseProvider>(context, listen: false);

    Stream<QuerySnapshot<Map<String, dynamic>>> _salesStream =
        _dbProvider.salesStream;

    // Map<String, String> _selectedUser =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    List<SaleToReport> _salesList = [];

    // _salesStream.listen((event) {
    //   event.docs.map((element) {
    //     if (element.data()['user_seller']['external_id'] ==
    //         widget.currentUser.externalId) {
    //       _salesList.add(SaleToReport.fromJson(element.data()));
    //     }
    //   });
    // });
    return StreamBuilder(
      stream: _salesStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.none:
            return Center(child: Text('None'));
          case ConnectionState.done:
          case ConnectionState.active:
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final docs = snapshot.data!.docs;
              if (_salesList.isNotEmpty) {
                _salesList.clear();
              }
              docs.forEach((sale) {
                if (sale.get('user_seller')['external_id'].toString() ==
                        widget.currentUser.externalId &&
                    DateTime.fromMillisecondsSinceEpoch(
                                sale.get('date_created').millisecondsSinceEpoch)
                            .day ==
                        DateTime.now().day) {
                  _salesList.add(SaleToReport.fromJson(sale.data()));
                }
              });

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _salesList.length,
                itemBuilder: (BuildContext context, int index) {
                  num _total = double.parse(_salesList[index].cashInstallment) +
                      double.parse(_salesList[index].mpInstallment);

                  return _salesList.isEmpty
                      ? Center(
                          child: Text(
                              '${widget.currentUser.userName} no hay realizó ventas hoy'),
                        )
                      : Column(
                          children: [
                            ListTile(
                              title: Center(
                                  child: Text(
                                      '${_salesList[index].customerName}')),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Efectivo: \$ ${_salesList[index].cashInstallment}'),
                                  Text(
                                      'MercadoPago: \$ ${_salesList[index].mpInstallment}'),
                                  Text('Total recibido: \$' +
                                      _total.toStringAsFixed(2)),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        );
                },
              );
            }
          // case ConnectionState.active:
          //   return Center(child: Text('active'));
          // default:
          //   return Center(child: Text('No hay datos'));
        }
        // if (!snapshot.hasData) {
        //   return Center(child: CircularProgressIndicator());
        // }
        // if (snapshot.hasError) {
        //   return Center(
        //     child: Text('ERROR'),
        //   );
        // }
        // final docs = snapshot.data!.docs;
        // if (_salesList.isNotEmpty) {
        //   _salesList.clear();
        // }
        // docs.forEach((sale) {
        //   if (sale.get('user_seller')['external_id'].toString() ==
        //           widget.currentUser.externalId &&
        //       DateTime.fromMillisecondsSinceEpoch(
        //                   sale.get('date_created').millisecondsSinceEpoch)
        //               .day ==
        //           DateTime.now().day) {
        //     _salesList.add(SaleToReport.fromJson(sale.data()));
        //   }
        // });

        // return ListView.builder(
        //   physics: BouncingScrollPhysics(),
        //   itemCount: _salesList.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     num _total = double.parse(_salesList[index].cashInstallment) +
        //         double.parse(_salesList[index].mpInstallment);

        //     return _salesList.isEmpty
        //         ? Center(
        //             child: Text(
        //                 '${widget.currentUser.userName} no hay realizó ventas hoy'),
        //           )
        //         : Column(
        //             children: [
        //               ListTile(
        //                 title: Center(
        //                     child: Text('${_salesList[index].customerName}')),
        //                 subtitle: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                         'Efectivo: \$ ${_salesList[index].cashInstallment}'),
        //                     Text(
        //                         'MercadoPago: \$ ${_salesList[index].mpInstallment}'),
        //                     Text('Total recibido: \$' +
        //                         _total.toStringAsFixed(2)),
        //                   ],
        //                 ),
        //               ),
        //               Divider(),
        //             ],
        //           );
        //   },
        // );
      },
    );
    // reportProvider.salesList.forEach((sale) {
    //   if (sale.userSeller.externalId == _selectedUser['userId'] &&
    //       sale.dateCreated.day == DateTime.now().day) {
    //     _salesList.add(sale);
    //   }
    // });
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Ventas de: ${_selectedUser['userName']}'),
    //   ),
    //   body: _salesList.isEmpty
    //       ? Center(
    //           child: Text('No hay ventas hoy'),
    //         )
    //       : ListView.builder(
    //           physics: BouncingScrollPhysics(),
    //           itemCount: _salesList.length,
    //           itemBuilder: (context, index) {
    //             if (_salesList.isEmpty) {
    //               return Center(
    //                 child: CircularProgressIndicator(),
    //               );
    //             }
    //             return Column(
    //               children: [
    //                 ListTile(
    //                   title: Text('Cliente: ${_salesList[index].customerName}'),
    //                   subtitle: Text('Fecha: ' +
    //                       Utils.formatDate(_salesList[index].dateCreated)),
    //                 ),
    //                 Divider(),
    //               ],
    //             );
    //           },
    //         ),
    // );
  }
}
