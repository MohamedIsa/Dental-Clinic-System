import 'package:flutter/material.dart';
import 'package:senior/admin/side_menu_data.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({Key? key}) : super(key: key);

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  late String currentRouteName; // Track the current route name

  @override
  void initState() {
    super.initState();
    currentRouteName = '/admin'; // Set initial route name
  }

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Center(
      child: Drawer(
        child: Container(
          color: Color.fromARGB(255, 39, 39, 40),
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
          Colors.blue, // Change the background color of the selected item
      onTap: () {
        setState(() {
          currentRouteName =
              data.menu[index].routeName; // Update current route name
        });
        Navigator.pushNamed(context, data.menu[index].routeName);
      },
      leading: Icon(
        data.menu[index].icon,
        color: isSelected ? Colors.white : Colors.grey,
      ),
      title: Text(
        data.menu[index].title,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
