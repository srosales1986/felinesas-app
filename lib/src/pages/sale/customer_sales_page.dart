import 'package:chicken_sales_control/src/pages/customer/customer_list_view_builder.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerSalesPage extends StatefulWidget {
  CustomerSalesPage({Key? key}) : super(key: key);

  @override
  _CustomerSalesPageState createState() => _CustomerSalesPageState();
}

// TODO: Mostrar lista de clientes o repartidores para acceder a las ventas de c/u.
class _CustomerSalesPageState extends State<CustomerSalesPage> {
  @override
  Widget build(BuildContext context) {
    final fbProvider = Provider.of<FirebaseProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: Container(
        child: Center(
          child: CustomerListViewBuilder(
              customerCollection: fbProvider.fbCustomersCollectionRef),
        ),
      ),
    );
  }
}
