import 'package:flutter/material.dart';

class IndicatorProvider extends ChangeNotifier{
  double max = 2500;
  double current = 0;

  setMax(double value){
    max = value;
    notifyListeners();
  }

  setCurrent(double value){
    current = value;
    notifyListeners();
  }
}