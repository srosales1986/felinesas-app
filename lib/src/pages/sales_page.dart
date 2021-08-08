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
          actions: [
            ButtonBar(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                )
              ],
            ),
          ],
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
    // child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //     future: getAllCustomers,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return Text('Eroor');
    //       }
    //       if (!snapshot.hasData) {
    //         return Center(
    //             child: CircularProgressIndicator.adaptive());
    //       }
    //       if (snapshot.hasData &&
    //           customerProvider.customerList.isEmpty) {
    //         customerProvider.fillCustomerList(snapshot.data!.docs
    //             .map((e) => Customer.fromJson(e.data()))
    //             .toList());

    //         print(customerProvider.customerList.length);
    //         return ListView(
    //           children: CustomerService.getCustomerListTile(
    //               customerProvider.customerList),
    //         );
    //       }
    //       if (customerProvider.customerList.isNotEmpty) {
    //         return ListView(
    //           children: CustomerService.getCustomerListTile(
    //               customerProvider.customerList),
    //         );
    //       }

    //       return Container(
    //         color: Colors.white,
    //         child: Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     })))
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
