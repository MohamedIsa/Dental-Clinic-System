import 'package:flutter/material.dart';
import 'package:senior/pages/home/auth/facultyhome/settings/staff_managment.dart';
import 'dentist_color.dart';
import 'edit_message.dart';
import 'settings_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: SettingsPage(
                  navigateToSettings: (settingName) {
                    switch (settingName) {
                      case 'Staff Management':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffManagementScreen()),
                        );
                        break;
                      case 'Dentist Color':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DentistColorSettingsScreen()),
                        );
                        break;
                      case 'Edit Message':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditMessageScreen()),
                        );
                        break;
                      default:
                        print('Setting not found');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
