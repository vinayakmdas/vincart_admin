import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeScreen(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}