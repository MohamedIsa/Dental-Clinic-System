import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../providers/side_menu_provider.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  String userName = "";

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(0),
          child: Drawer(
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
            child: Container(
              color: Colors.blue,
              child: ListView.builder(
                itemCount: sideMenuProvider.menu.length,
                itemBuilder: (context, index) =>
                    buildMenuEntry(sideMenuProvider, index, context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuEntry(
      SideMenuProvider sideMenuProvider, int index, BuildContext context) {
    final isSelected = sideMenuProvider.menu[index].routeName ==
        ModalRoute.of(context)?.settings.name;

    return GestureDetector(
      onTap: () {
        onMenuItemClick(context, sideMenuProvider.menu[index].routeName, index);
      },
      child: Container(
        color: isSelected
            ? const Color.fromARGB(255, 0, 58, 106).withOpacity(0.5)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(
              sideMenuProvider.menu[index].icon,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(width: 10),
            Text(
              sideMenuProvider.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 255, 255, 255),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onMenuItemClick(BuildContext context, String routeName, int index) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute != routeName) {
      Provider.of<SideMenuProvider>(context, listen: false)
          .updateIndex(index, routeName);
      context.go(routeName);
    }
  }
}
