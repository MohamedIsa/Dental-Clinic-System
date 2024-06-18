import 'package:flutter/material.dart';
import 'package:senior/receptionist/side_menu_data.dart';

class ReceptionistSideMenuWidget extends StatefulWidget {
  const ReceptionistSideMenuWidget({Key? key}) : super(key: key);

  @override
  State<ReceptionistSideMenuWidget> createState() => _SideMenuWidgetState();
}

String currentRouteName = '';

class _SideMenuWidgetState extends State<ReceptionistSideMenuWidget> {
  String userName = "Admin"; // Default user name

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();
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
                itemCount: data.menu.length,
                itemBuilder: (context, index) =>
                    buildMenuEntry(data, index, context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuEntry(
      SideMenuData data, int index, BuildContext context) {
    final isSelected = data.menu[index].routeName == currentRouteName;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentRouteName = data.menu[index].routeName;
        });
        Navigator.pushNamed(context, data.menu[index].routeName);
      },
      child: Container(
        color: isSelected
            ? const Color.fromARGB(255, 0, 58, 106).withOpacity(0.5)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(
              data.menu[index].icon,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(width: 10),
            Text(
              data.menu[index].title,
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
}