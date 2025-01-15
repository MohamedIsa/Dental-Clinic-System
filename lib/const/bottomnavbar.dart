import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/navbaritem.dart';
import 'app_colors.dart';
import '../providers/navbar_provider.dart';

class BottomNavBar<T extends NavBarProvider> extends StatelessWidget {
  final List<NavBarItem> navItems;
  BottomNavBar({super.key, required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, navBarProvider, child) {
        return BottomNavigationBar(
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
          selectedLabelStyle: const TextStyle(color: AppColors.primaryColor),
          showUnselectedLabels: true,
          currentIndex: navBarProvider.selectedIndex,
          items: navItems
              .map((item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  ))
              .toList(),
          onTap: (index) {
            onMenuItemClick(context, navItems[index].route, index);
          },
        );
      },
    );
  }

  void onMenuItemClick(BuildContext context, String routeName, int index) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute != routeName) {
      Provider.of<T>(context, listen: false).updateIndex(index, routeName);
      Navigator.pushNamed(context, routeName);
    }
  }
}
