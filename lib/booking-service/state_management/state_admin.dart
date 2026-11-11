import 'package:flutter/material.dart';

class AdminState extends ChangeNotifier {
  String username = '';

  String get getUsername => username;

  void setUsername(String value) {
    username = value;
  }

  String password = '';

  String get getPassword => password;

  void setPassword(String value) {
    password = value;
  }
}
