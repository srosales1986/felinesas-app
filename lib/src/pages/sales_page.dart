import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/CustomerService.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesPage extends StatefulWidget {
  SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  // final Future<List<Customer>> futureCustomer = CustomerService.fetchCustomer();

  @override
  Widget build(BuildContext context) {
    var customerProvider = Provider.of<CustomerProvider>(context, listen: true);
    // var _db = FirebaseFirestore.instance;

    // Future<QuerySnapshot<Map<String, dynamic>>> getAllCustomers =
    //     _db.collection('custmers').get();
    // print('buildSalesPage');

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.home),
          ),
          title: Text('Clientes'),
        ),
        body: Scrollbar(
          thickness: 20,
          child: Scrollbar(
            child: ListView(
              children: CustomerService.getCustomerListTile(
                  customerProvider.customerList, context),
            ),
          ),
        ));
  }

  Widget listTileOfCustomer(Customer customer) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 2.0,
          semanticContainer: false,
          child: ListTile(
            leading: Icon(
              Icons.account_circle,
              size: 50,
            ),
            title: Text(customer.name),
            subtitle: Text('${customer.address} - ${customer.ivaCond}'),
            onTap: () {
              Navigator.pushNamed(context, 'add_products_page');
            },
          ),
        ),
        // Divider(),
      ],
    );
  }
}
