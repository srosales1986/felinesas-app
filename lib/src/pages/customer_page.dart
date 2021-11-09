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

    Widget _bottonAction(IconData icon) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Icon(
            icon,
            size: 30.0,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottonAction(Icons.home),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton:
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'new_customer_page');
        },
      ),
    );
  }
}

enum MenuOption { INFO, EDIT, DELETE }

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

    if (customerList.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.grey,
          ),
          Text(
            '¡No hay clientes registrados!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ));
    }

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: customerList.length,
        itemBuilder: (context, index) {
          if (customerList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 1,
                leading: Icon(
                  Icons.store,
                  size: 50,
                  color: Colors.orange.shade400,
                ),
                trailing: PopupMenuButton<MenuOption>(
                  itemBuilder: (context) {
                    return <PopupMenuEntry<MenuOption>>[
                      PopupMenuItem(
                        child: Text('Info'),
                        value: MenuOption.INFO,
                      ),
                      PopupMenuItem(
                        child: Text('Editar'),
                        value: MenuOption.EDIT,
                      ),
                      PopupMenuItem(
                        child: Text('Eliminar'),
                        value: MenuOption.DELETE,
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == MenuOption.DELETE) {
                      showDeteleDialog(context, customerList, index);
                    }
                    if (value == MenuOption.EDIT) {
                      Navigator.pushReplacementNamed(
                          context, 'new_customer_page',
                          arguments: customerList[index]);
                    }
                    if (value == MenuOption.INFO) {
                      TextStyle cardSubTitleStyle = TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      );
                      TextStyle cardTextStyle = TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black87);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BounceInUp(
                            duration: Duration(milliseconds: 200),
                            child: AlertDialog(
                              actionsAlignment: MainAxisAlignment.center,
                              title: Center(
                                child: Text(customerList[index].name),
                              ),
                              content: buildCardCustomerInfo(
                                cardTextStyle,
                                cardSubTitleStyle,
                                customerList,
                                index,
                              ),
                              actions: [
                                TextButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(300, 60)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Container(child: Text('OK')),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
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
  }

  Card buildCardCustomerInfo(TextStyle cardTextStyle,
      TextStyle cardSubTitleStyle, List<Customer> customerList, int index) {
    return Card(
      elevation: 8,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(style: cardTextStyle, children: [
                TextSpan(style: cardSubTitleStyle, text: 'CUIT: '),
                TextSpan(text: '${customerList[index].cuit}'),
              ]),
            ),
            Divider(),
            RichText(
              text: TextSpan(style: cardTextStyle, children: [
                TextSpan(style: cardSubTitleStyle, text: 'Dirección: '),
                TextSpan(text: '${customerList[index].address}'),
              ]),
            ),
            Divider(),
            RichText(
              text: TextSpan(style: cardTextStyle, children: [
                TextSpan(style: cardSubTitleStyle, text: 'Cond. IVA: '),
                TextSpan(text: '${customerList[index].ivaCond}'),
              ]),
            ),
            Divider(),
            RichText(
              text: TextSpan(style: cardTextStyle, children: [
                TextSpan(style: cardSubTitleStyle, text: 'Saldo: '),
                TextSpan(text: '\$${customerList[index].balance}'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                DELETE DIALOG                               */
  /* -------------------------------------------------------------------------- */

  Future<dynamic> showDeteleDialog(
      BuildContext context, List<Customer> customerList, int index) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return BounceInUp(
            duration: Duration(milliseconds: 200),
            child: AlertDialog(
              title: Text('Eliminar cliente'),
              content: Container(
                child: Text('¿Está seguro que desea eliminar el cliente?'),
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
}
