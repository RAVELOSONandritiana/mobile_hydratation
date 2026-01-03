import 'package:flutter/material.dart';

class CompteProvider extends ChangeNotifier{
  bool notify = false;
  double maxValue = 0;
  int id = 0;

  toggleNotify(){
    notify = !notify;
    notifyListeners();
  }

  setMaxValue(double value){
    maxValue = value;
    notifyListeners();
  }

  setId(int value){
    id = value;
    notifyListeners();
  }
}