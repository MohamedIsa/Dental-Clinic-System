import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/navbaritem.dart';
import 'app_colors.dart';
import '../providers/navbar_provider.dart';

class TopNavBar<T extends NavBarProvider> extends StatelessWidget {
  final List<NavBarItem> navItems;
  const TopNavBar({super.key, required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, navBarProvider, child) {
        return Container(
          color: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: navItems.map((item) {
                  return _buildNavButton(context, item.label, () {
                    onMenuItemClick(
                        context, item.route, navItems.indexOf(item));
                  });
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  TextButton _buildNavButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }

  void onMenuItemClick(BuildContext context, String routeName, int index) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute != routeName) {
      Navigator.pushNamed(context, routeName);
    } else {
      print('Already on the current route: $routeName');
    }
  }
}
