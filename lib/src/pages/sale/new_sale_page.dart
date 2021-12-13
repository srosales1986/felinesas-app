import 'package:chicken_sales_control/src/pages/customer/customer_list_view_builder.dart';
import 'package:chicken_sales_control/src/pages/customer/search/CustomerSearchDelegate.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class NewSalePage extends StatelessWidget {
  const NewSalePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerCollection =
        Provider.of<FirebaseProvider>(context, listen: false)
            .fbCustomersCollectionRef;
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Seleccione el cliente'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
                context: context,
                delegate: CustomerSearchDelegate(
                    customerProvider, 'add_products_page')),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ElasticInRight(
        from: -200,
        duration: Duration(milliseconds: 300),
        child: Container(
          child: CustomerListViewBuilder(
            customerCollection: customerCollection,
            isToSaleOrPayment: true,
            navigateTo: 'add_products_page',
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, 'delivery_boy_home_page');
              },
              icon: Icon(Icons.home),
            ),
          ],
        ),
      ),
    );
  }
}
