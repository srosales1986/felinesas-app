import 'package:chicken_sales_control/src/custom_widgets/custom_widgets.dart';
import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/UserProvider.dart';
import 'package:chicken_sales_control/src/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _db = Provider.of<FirebaseProvider>(context, listen: false);
    final getAllUsers = _db.fbUsersCollectionRef.get();
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getAllUsers,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Center(child: Text('Error'));
          }
          if (!snapshot.hasData) {
            return Container(
              color: Colors.blue,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else {
            if (snapshot.hasData && userProvider.userList.isEmpty) {
              userProvider.fillUserList(snapshot.data!.docs
                  .map((e) => UserModel.fromJson(e.id, e.data()))
                  .toList());

              return _LoginScreen();
            } else {
              if (userProvider.userList.isNotEmpty) {
                return _LoginScreen();
              }
              return Container(
                color: Colors.blue,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
          }
        });
  }
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              CardContainer(
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _LoginFrom(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginFrom extends StatelessWidget {
  const _LoginFrom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    var userPovider = Provider.of<UserProvider>(context, listen: false);

    return Container(
      child: Form(
        child: Column(
          children: [
            _UserDropDownButtonFormField(),
            SizedBox(
              height: 10,
            ),
            _PassTextFormField(),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  userPovider.setIsLoading(true);
                  authService
                      .login(
                    userPovider.currentUser.email,
                    userPovider.currentUser.password.toString(),
                  )
                      .then((value) {
                    if (value == 'Logged In') {
                      try {
                        final authService = FirebaseAuth.instance;
                        final uId = authService.currentUser!.uid;

                        userPovider.currentUser.externalId = uId;

                        final indexOfCurrentUser = userPovider.userList
                            .indexWhere((user) => user.externalId == uId);

                        userPovider.currentUser.rol =
                            userPovider.userList[indexOfCurrentUser].rol;
                      } on Exception catch (e) {
                        print(e);
                      }

                      FocusScope.of(context).unfocus();
                      Navigator.pushReplacementNamed(
                          context, 'delivery_boy_home_page');
                      userPovider.setIsLoading(false);
                    } else {
                      final snackBar = SnackBar(
                        content: const Text('¡Contraseña incorrecta!'),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('No Logged');
                    }
                  });
                },
                child: userPovider.isLoading
                    ? Text('ESPERE...')
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        child: Text('INGRESAR'),
                      )),
          ],
        ),
      ),
    );
  }
}

class _UserDropDownButtonFormField extends StatefulWidget {
  const _UserDropDownButtonFormField({
    Key? key,
  }) : super(key: key);

  @override
  _UserDropDownButtonFormFieldState createState() =>
      _UserDropDownButtonFormFieldState();
}

class _UserDropDownButtonFormFieldState
    extends State<_UserDropDownButtonFormField> {
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    var userPovider = Provider.of<UserProvider>(context, listen: false);

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Usuario',
      ),
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          userPovider.currentUser.email = dropdownValue.toString();
        });
      },
      items:
          userPovider.userList.map<DropdownMenuItem<String>>((UserModel user) {
        if (user.email == userPovider.currentUser.email) {
          userPovider.currentUser.userName = user.userName;
        }
        return DropdownMenuItem<String>(
          value: user.email,
          child: Text(user.userName),
        );
      }).toList(),
    );
  }
}

class _PassTextFormField extends StatefulWidget {
  _PassTextFormField({Key? key}) : super(key: key);

  @override
  __PassTextFormFieldState createState() => __PassTextFormFieldState();
}

class __PassTextFormFieldState extends State<_PassTextFormField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    // TextEditingController userPasswordController = TextEditingController();
    var userPovider = Provider.of<UserProvider>(context, listen: false);

    return TextFormField(
      onChanged: (String? value) {
        userPovider.currentUser.password = value.toString().trim();
      },
      // initialValue: userPovider.currentUser.password ?? null,
      // controller: userPasswordController,
      obscureText: _obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.length < 6) {
          return 'Ingrese al menos 6 caracteres';
        } else {
          return null;
        }
      },
      autocorrect: false,
      decoration: InputDecoration(
        hintText: '******',
        labelText: 'Contraseña',
        suffixIcon: Padding(
          padding: EdgeInsets.only(top: 15),
          child: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: _obscureText
                  ? Icon(Icons.visibility_outlined)
                  : Icon(Icons.visibility_off_outlined)),
        ),
      ),
    );
  }
}
