import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class NewSalePage extends StatelessWidget {
  const NewSalePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Nueva Venta'),
      ),
      body: ElasticInRight(
        from: -200,
        duration: Duration(milliseconds: 300),
        child: Container(
          child: CustomerListView(),
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

class CustomerListView extends StatelessWidget {
  const CustomerListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: true);

    final List<Customer> customerList = customerProvider.customerList;

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: customerList.length,
        itemBuilder: (context, index) {
          if (customerList.isEmpty) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          return Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, 'add_products_page',
                      arguments: customerList[index]);
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 1,
                leading: Icon(
                  Icons.store,
                  size: 50,
                  color: Colors.orange,
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
}
