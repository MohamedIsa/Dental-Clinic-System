import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../const/app_colors.dart';
import '../../../utils/responsive_widget.dart';
import '../../../functions/phome/getusername.dart';

class PatientAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PatientAppBar({super.key});

  @override
  State<PatientAppBar> createState() => _PatientAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PatientAppBarState extends State<PatientAppBar> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AppBar(
      title: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/logoh.png',
            width: width * 0.09,
            height: height * 0.09,
          ),
          SizedBox(width: ResponsiveWidget.isLargeScreen(context) ? 800 : 40),
          FutureBuilder<String>(
            future: getFullName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                  'Welcome, ${snapshot.data}!',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            context.go('/home');
          },
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}
