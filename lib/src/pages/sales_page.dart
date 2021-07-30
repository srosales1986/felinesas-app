import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/CustomerService.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final Future<List<Customer>> futureCustomer = CustomerService.fetchCustomer();

  @override
  Widget build(BuildContext context) {
    // var productsProvider = Provider.of<ProductsProvider>(context, listen: true);

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
        body: Column(children: [
          Expanded(
              child: Container(
                  child: FutureBuilder<List<Customer>>(
                      future: futureCustomer,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Eroor');
                        }
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator.adaptive());
                        }
                        return ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 0),
                          children: snapshot.data!
                              .map((customer) => listTileOfCustomer(customer))
                              .toList(),
                        );
                      })))
        ]));
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
            subtitle: Text('${customer.address} - ${customer.condIva}'),
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
