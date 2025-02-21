import 'package:flutter/material.dart';

class BottomNavIndexProvider extends ChangeNotifier {
  int _index = 0;

  get selectedIndex => _index;

  reset(int newValue) {
    _index = newValue;
    notifyListeners();
  }
}
