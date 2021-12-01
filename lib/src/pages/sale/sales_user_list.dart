import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesUserList extends StatelessWidget {
  const SalesUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userList = userProvider.userList;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Seleccione un usuario'),
      ),
      body: userList.isEmpty
          ? Center(
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
            ))
          : UserListViewBuilder(userList: userList),
    );
  }
}

class UserListViewBuilder extends StatelessWidget {
  const UserListViewBuilder({
    Key? key,
    required this.userList,
  }) : super(key: key);

  final List<UserModel> userList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          if (userList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  minVerticalPadding: 1,
                  onTap: () {
                    Navigator.pushNamed(context, 'sales_by_user_page',
                        arguments: userList[index]);
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
          }
        });
  }
}
