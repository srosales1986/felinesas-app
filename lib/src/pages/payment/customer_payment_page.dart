import 'package:chicken_sales_control/src/pages/customer/customer_list_view_builder.dart';
import 'package:chicken_sales_control/src/pages/customer/search/CustomerSearchDelegate.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPaymentPage extends StatelessWidget {
  const CustomerPaymentPage({Key? key}) : super(key: key);

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
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Seleccione el Cliente'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
                context: context,
                delegate:
                    CustomerSearchDelegate(customerProvider, 'payment_page')),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: CustomerListViewBuilder(
        customerCollection: customerCollection,
        isToSaleOrPayment: true,
        navigateTo: 'payment_page',
        // onTap: () {
        //   Navigator.pushReplacementNamed(context, 'payment_page');
        // },
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
