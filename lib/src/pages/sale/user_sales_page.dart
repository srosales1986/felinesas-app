import 'package:chicken_sales_control/src/pages/sale/user_list_view_builder.dart';
import 'package:flutter/material.dart';

class UserSalesPage extends StatefulWidget {
  UserSalesPage({Key? key}) : super(key: key);

  @override
  _UserSalesPageState createState() => _UserSalesPageState();
}

class _UserSalesPageState extends State<UserSalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: Container(
        child: UserListViewBuilder(),
      ),
    );
  }
}
