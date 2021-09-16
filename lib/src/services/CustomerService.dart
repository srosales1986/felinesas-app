import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:chicken_sales_control/src/models/Customer_model.dart';
// import 'package:http/http.dart' as http;

class CustomerService {
// TODO: Convertir el ListView de clientes en un widget reutilizable

  static getCustomerListTile(Function? onTapFunction, BuildContext context) {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: true);
    final customerList = customerProvider.customerList;
    // var saleProvider = Provider.of<SaleProvider>(context, listen: false);

    List<Widget> customerListTile = [];
    customerList.forEach((customer) {
      customerListTile.add(Column(
        children: [
          ListTile(
            onTap: () => onTapFunction!(customer),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            minVerticalPadding: 1,
            leading: Icon(
              Icons.account_circle,
              size: 50,
              color: Color(0xFFadcbff),
            ),
            title: Text(
              customer.name,
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(customer.address),
              ],
            ),
          ),
          Divider(),
        ],
      ));
    });
    return customerListTile;
  }
}
