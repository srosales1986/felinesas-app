import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListViewBuilder extends StatefulWidget {
  // final CollectionReference<Map<String, dynamic>> userCollection;
  final Widget? trailing;
  final Function? onTap;
  final bool? isToSaleOrPayment;
  final bool? isToManagment;
  final String? navigateTo;

  const UserListViewBuilder({
    Key? key,
    // required this.userCollection,
    this.trailing,
    this.onTap,
    this.isToSaleOrPayment,
    this.isToManagment,
    this.navigateTo,
  }) : super(key: key);

  @override
  State<UserListViewBuilder> createState() => _UserListViewBuilderState();
}

class _UserListViewBuilderState extends State<UserListViewBuilder> {
  @override
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final userList = userProvider.userList;

    if (userList.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.grey,
          ),
          Text(
            '¡No hay usuarios en la lista!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ));
    }
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          if (userList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 1,
                onTap: () {
                  Navigator.pushNamed(context, 'sales_by_user_page',
                      arguments: {
                        'userId': userList[index].externalId,
                        'userName': userList[index].userName,
                      });
                },
                leading: Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.blue.shade400,
                ),
                title: Text(
                  userList[index].userName,
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              Divider(),
            ],
          );
        });
  }
}
