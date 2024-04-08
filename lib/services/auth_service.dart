import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<bool> register(String email, String password) async {
    if (_users.any((user) => user.email == email)) {
      return false;
    }

    _users.add(User(email: email, password: password));
    return true;
  }

  Future<bool> login(String email, String password) async {
    if (_users.any((user) => user.email == email && user.password == password)) {
      return true;
    }

    return false;
  }
}
