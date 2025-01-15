import 'package:flutter/material.dart';

abstract class NavBarProvider with ChangeNotifier {
  int _selectedIndex = 0;
  String _currentRoute = '';

  int get selectedIndex => _selectedIndex;
  String get currentRoute => _currentRoute;

  void updateIndex(int index, String route) {
    _selectedIndex = index;
    _currentRoute = route;
    notifyListeners();
  }
}
