import 'package:chicken_sales_control/src/pages/customer/customer_list_view_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Clientes'),
      ),
      body: ElasticInRight(
        from: -200,
        duration: Duration(milliseconds: 300),
        child: Container(
          child: CustomerListViewBuilder(
            customerCollection:
                FirebaseFirestore.instance.collection('customers'),
            isToManagment: true,
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
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'new_customer_page');
        },
      ),
    );
  }
}
