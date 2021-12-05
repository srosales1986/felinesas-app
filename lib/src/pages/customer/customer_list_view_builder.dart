import 'package:animate_do/animate_do.dart';
import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerListViewBuilder extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> customerCollection;
  final Widget? trailing;
  final Function? onTap;
  final bool? isToSaleOrPayment;
  final bool? isToManagment;
  final String? navigateTo;

  const CustomerListViewBuilder({
    Key? key,
    required this.customerCollection,
    this.trailing,
    this.onTap,
    this.isToSaleOrPayment,
    this.isToManagment,
    this.navigateTo,
  }) : super(key: key);

  @override
  State<CustomerListViewBuilder> createState() =>
      _CustomerListViewBuilderState();
}

class _CustomerListViewBuilderState extends State<CustomerListViewBuilder> {
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
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    final customerList = customerProvider.customerList;
    customerList.sort((a, b) => a.name.compareTo(b.name));

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
                onTap: () {
                  if (widget.isToSaleOrPayment != null &&
                      widget.navigateTo != null) {
                    switch (widget.navigateTo) {
                      case 'add_products_page':
                        saleProvider.currentCustomer = customerList[index];
                        Navigator.pushNamed(context, 'add_products_page');
                        break;
                      case 'payment_page':
                        Navigator.pushNamed(context, 'payment_page',
                            arguments: customerList[index]);
                    }
                  } else {
                    if (widget.onTap != null) {
                      return widget.onTap!();
                    }
                  }
                },
                leading: Icon(
                  Icons.store_rounded,
                  size: 50,
                  color: Colors.blue.shade400,
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
                    Text(
                        'Saldo: \$${customerList[index].balance.toStringAsFixed(2)}'),
                  ],
                ),
                trailing: widget.isToManagment == true
                    ? popupMenuButtoBuilder(context, customerList, index)
                    : widget.trailing != null
                        ? widget.trailing
                        : null,
              ),
              Divider(),
            ],
          );
        });
  }
}

enum MenuOption { INFO, EDIT, DELETE }

PopupMenuButton<MenuOption> popupMenuButtoBuilder(
    BuildContext context, List<Customer> customerList, int index) {
  return PopupMenuButton<MenuOption>(
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
        Navigator.pushReplacementNamed(context, 'new_customer_page',
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
                      fixedSize: MaterialStateProperty.all(Size(300, 60)),
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
  );
}

Card buildCardCustomerInfo(TextStyle cardTextStyle, TextStyle cardSubTitleStyle,
    List<Customer> customerList, int index) {
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
                  FirebaseFirestore.instance
                      .collection('customers')
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
