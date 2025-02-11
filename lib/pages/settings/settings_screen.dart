import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/pages/staff/staff_managment.dart';
import '../../utils/data.dart';
// import '../dentistcolor/dentist_color.dart';
import '../dentistcolor/dentist_color.dart';
import '../editmessage/edit_message.dart';
import 'settings_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    Data.checkUserAndNavigate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
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
