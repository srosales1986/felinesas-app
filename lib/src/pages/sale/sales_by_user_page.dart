import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_by_user_list_builder.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';

class SalesByUserPage extends StatelessWidget {
  const SalesByUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('${Utils.formatDateWithoutHms(DateTime.now())}',
                style: TextStyle(fontSize: 14)),
            Text(
              'Ventas de ${_currentUser.userName}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: SalesByUserListBuilder(currentUser: _currentUser),
    );
  }
}
