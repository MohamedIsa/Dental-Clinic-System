import 'package:flutter/material.dart';

import '../../../utils/responsive_widget.dart';

class WelcomeNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const WelcomeNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isSmallScreen(context)
        ? BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            selectedLabelStyle: TextStyle(color: Colors.blue),
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Book Appointment',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Appointment History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Update Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'Edit Appointment',
              ),
            ],
            onTap: onItemTapped,
          )
        : Container();
  }
}
