import 'package:flutter/material.dart';
import '../pages/widgets/navigations/side_menu_data.dart';
import '../models/side_menu_model.dart';
import 'navbar_provider.dart';

class SideMenuProvider extends NavBarProvider {
  final SideMenuData _sideMenuData = SideMenuData();
  List<MenuModel> _menu = [];

  List<MenuModel> get menu => _menu;

  Future<void> loadMenu(BuildContext context) async {
    await _sideMenuData.loadMenu(context);
    _menu = _sideMenuData.menu;
    notifyListeners();
  }
}
