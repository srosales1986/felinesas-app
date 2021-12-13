import 'package:chicken_sales_control/src/models/Customer_model.dart';
import 'package:chicken_sales_control/src/services/CustomersProvider.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerSearchDelegate extends SearchDelegate {
  final CustomerProvider customerProvider;
  List<Customer> _filterCustomer = [];

  CustomerSearchDelegate(this.customerProvider);

  @override
  String? get searchFieldLabel => 'Buscar cliente';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return CustomerListViwBuilder(
      query: query,
      filterCustomer: _filterCustomer,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Icon(
          Icons.search,
          size: 120,
          color: Colors.grey.shade300,
        ),
      );
    }
    // List<Customer> _filterCustomer = [];

    _filterCustomer = customerProvider.customerList.where((customer) {
      return customer.name.toLowerCase().contains(query.toLowerCase().trim());
    }).toList();
    return CustomerListViwBuilder(
      query: query,
      filterCustomer: _filterCustomer,
    );
  }
}

class CustomerListViwBuilder extends StatelessWidget {
  const CustomerListViwBuilder({
    Key? key,
    required this.query,
    required this.filterCustomer,
  }) : super(key: key);

  final String query;
  final List<Customer> filterCustomer;

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    return ListView.builder(
      itemCount: filterCustomer.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              minVerticalPadding: 1,
              onTap: () {
                saleProvider.currentCustomer = filterCustomer[index];
                Navigator.pushNamed(context, 'add_products_page');
              },
              leading: Icon(
                Icons.store_rounded,
                size: 50,
                color: Colors.blue.shade400,
              ),
              title: Text(
                filterCustomer[index].name,
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Saldo: \$${filterCustomer[index].balance.toStringAsFixed(2)}'),
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
