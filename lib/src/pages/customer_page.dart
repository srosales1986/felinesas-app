import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final customerProvider =
    // Provider.of<CustomerProvider>(context, listen: false);
    // final customerList = customerProvider.customerList;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'new_customer_page');
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Clientes'),
      ),
      body: ElasticInRight(
        from: -200,
        duration: Duration(milliseconds: 300),
        child: Container(
          child: CustomerListView(
            customerCollection:
                FirebaseFirestore.instance.collection('customers'),
          ),
        ),
      ),
    );
  }
}

enum MenuOption { Info, Editar, Eliminar }

class CustomerListView extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> customerCollection;
  const CustomerListView({
    Key? key,
    required this.customerCollection,
  }) : super(key: key);

  @override
  _CustomerListViewState createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView> {
  @override
  void initState() {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    widget.customerCollection.snapshots().listen((event) {
      List<Customer> customerList =
          event.docs.map((e) => Customer.fromJson(e.id, e.data())).toList();
      customerProvider.customerList = customerList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: true);

    final customerList = customerProvider.customerList;

    return ListView.builder(
        itemCount: customerList.length,
        itemBuilder: (context, index) {
          if (customerList.isEmpty) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 1,
                leading: Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Color(0xFFadcbff),
                ),
                trailing: PopupMenuButton<MenuOption>(
                  onSelected: (value) {
                    if (value == MenuOption.Eliminar) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return BounceInUp(
                              duration: Duration(milliseconds: 200),
                              child: AlertDialog(
                                title: Text('Eliminar cliente'),
                                content: Container(
                                  child: Text(
                                      '¿Está seguro que desea eliminar el cliente?'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      widget.customerCollection
                                          .doc(customerList[index].id)
                                          .delete();
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  },
                  itemBuilder: (context) {
                    return <PopupMenuEntry<MenuOption>>[
                      PopupMenuItem(
                        child: Text('Info'),
                        value: MenuOption.Info,
                      ),
                      PopupMenuItem(
                        child: Text('Editar'),
                        value: MenuOption.Editar,
                      ),
                      PopupMenuItem(
                        child: Text('Eliminar'),
                        value: MenuOption.Eliminar,
                      ),
                    ];
                  },
                ),
                title: Text(
                  customerList[index].name,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(customerList[index].address),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        });

    // List<Widget> customerListTile = [];

    // customerList.forEach((customer) {
    //   customerListTile.add(Column(
    //     children: [
    //       ListTile(
    //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
    //         minVerticalPadding: 1,
    //         leading: Icon(
    //           Icons.account_circle,
    //           size: 50,
    //           color: Color(0xFFadcbff),
    //         ),
    //         trailing: PopupMenuButton<MenuOption>(
    //           itemBuilder: (context) {
    //             return <PopupMenuEntry<MenuOption>>[
    //               PopupMenuItem(
    //                 child: Text('Info'),
    //                 value: MenuOption.Info,
    //               ),
    //               PopupMenuItem(
    //                 child: Text('Editar'),
    //                 value: MenuOption.Editar,
    //               ),
    //               PopupMenuItem(
    //                 child: Text('Eliminar'),
    //                 value: MenuOption.Eliminar,
    //               ),
    //             ];
    //           },
    //         ),
    //         title: Text(
    //           customer.name,
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         subtitle: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           // mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Text(customer.address),
    //           ],
    //         ),
    //       ),
    //       Divider(),
    //     ],
    //   ));
    // });

    // return Scrollbar(
    //   child: ListView(
    //     physics: BouncingScrollPhysics(),
    //     children: customerListTile,
    //   ),
    // );
  }
}
