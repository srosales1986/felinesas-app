import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/CustomersProvider.dart';
import '../../util/utils.dart';

class CurrentAccountAmountWidget extends StatelessWidget {
  const CurrentAccountAmountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: true);

    return StreamBuilder(
        stream: customerProvider.getCustomerStream(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          num total = 0;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CurrentAccountAmount(children: [
                Text('Cuenta Corriente'),
                Text(Utils.formatCurrency(
                    customerProvider.currentAccountAmount)),
              ]);

            case ConnectionState.none:
              return CurrentAccountAmount(children: [
                Text('None...'),
              ]);

            case ConnectionState.done:
            case ConnectionState.active:
              if (!snapshot.hasData) {
                return CurrentAccountAmount(children: [
                  Text('No data...'),
                ]);
              } else {
                snapshot.data!.docs.forEach((customer) {
                  total = total + customer.get('balance');
                });
                customerProvider.currentAccountAmount = total;
                return CurrentAccountAmount(
                  children: [
                    Text('Cuenta Corriente'),
                    Text(Utils.formatCurrency(
                        customerProvider.currentAccountAmount)),
                  ],
                );
              }
          }
        });
  }
}

class CurrentAccountAmount extends StatelessWidget {
  final List<Widget> children;

  const CurrentAccountAmount({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipInY(
      child: Container(
        alignment: AlignmentDirectional.topCenter,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
