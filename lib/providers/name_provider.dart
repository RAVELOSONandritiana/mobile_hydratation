import 'package:flutter/material.dart';

class NameProvider extends ChangeNotifier {
  String name = '';
  String accountState = '';
  String email = '';
  int id = 0;
  String profilePicture = '';

  setName(String name) {
    this.name = name;
    notifyListeners();
  }

  setEmail(String name) {
    email = name;
    notifyListeners();
  }

  setAccountState(String value) {
    accountState = value;
    notifyListeners();
  }

  setId(int value) {
    id = value;
    notifyListeners();
  }

  setProfilePicture(String value) {
    profilePicture = value;
    notifyListeners();
  }
}
