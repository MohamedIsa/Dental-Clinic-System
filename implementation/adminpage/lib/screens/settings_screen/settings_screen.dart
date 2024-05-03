
import 'package:adminpage/screens/settings_screen/widget/settings_widget.dart';
import 'package:adminpage/screens/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:adminpage/screens/header_widget.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HeaderWidget(userName: 'Ahmed Mahmood',) ,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SideMenuWidget(),
            ),
            Expanded(
              flex: 7,
              child: SettingsPage(),
            ),
            
          ],
        ),
      ),
    );
  }
}
