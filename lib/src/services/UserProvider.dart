import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _userList = [];
  UserModel _currentUser = UserModel(
      id: '', externalId: '', email: '', userName: '', rol: '', password: '');
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  void setIsLoading(bool value) => _isLoading = value;

  void fillUserList(List<UserModel> users) {
    this.userList.addAll(users);
  }

  List<UserModel> get userList => this._userList;

  UserModel get currentUser => this._currentUser;

  void updateCurrentUserEmail(String email) {
    this._currentUser.email = email;
  }

  void updateCurrentUserUserName(String userName) {
    this._currentUser.userName = userName;
  }

  void updateCurrentUserPass(String pass) {
    this._currentUser.password = pass;
  }
}
