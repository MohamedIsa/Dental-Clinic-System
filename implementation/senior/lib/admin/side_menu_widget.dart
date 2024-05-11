import 'package:flutter/material.dart';
import 'package:senior/admin/side_menu_data.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({Key? key}) : super(key: key);

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}
 String currentRouteName = '';
class _SideMenuWidgetState extends State<SideMenuWidget> {
  // Track the current route name
  String userName = "Admin"; // Default user name

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Center(
      child: Drawer(
        child: Container(
          color: const Color.fromARGB(171, 33, 149, 243),
          child: ListView.builder(
            itemCount: data.menu.length,
            itemBuilder: (context, index) =>
                buildMenuEntry(data, index, context),
          ),
        ),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index, BuildContext context) {
    final isSelected = data.menu[index].routeName == currentRouteName;

    return ListTile(
      selected: isSelected,
      selectedTileColor:
          const Color.fromARGB(255, 0, 58, 106).withOpacity(0.5), // Change the background color of the selected item
      onTap: () {
        setState(() {
          currentRouteName =
              data.menu[index].routeName; // Update current route name
        });
        Navigator.pushNamed(context, data.menu[index].routeName);
      },
      leading: Icon(
        data.menu[index].icon,
        color: isSelected ? Colors.white : const Color.fromARGB(255, 255, 255, 255),
      ),
      title: Text(
        data.menu[index].title,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? Colors.white : const Color.fromARGB(255, 255, 255, 255),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
