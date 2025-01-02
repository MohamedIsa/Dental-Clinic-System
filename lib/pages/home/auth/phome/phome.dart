import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:senior/const/navbaritems.dart';
import 'package:senior/const/bottomnavbar.dart';
import 'package:senior/pages/widgets/static/patientappbar.dart';
import 'package:senior/pages/widgets/static/patienthomebody.dart';
import 'package:senior/const/topnavbar.dart';
import '../../../../const/app_colors.dart';
import '../../../../providers/patient_navbar.dart';
import '../../../../utils/responsive_widget.dart';
import '../../../../functions/phome/getusername.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Scaffold(
        appBar: PatientAppBar(),
        bottomNavigationBar: ResponsiveWidget.isSmallScreen(context)
            ? BottomNavBar<PatientNavBarProvider>(
                navItems: [...navItemsp],
              )
            : null,
        body: FutureBuilder<String>(
          future: getFullName(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCube(
                  color: AppColors.primaryColor,
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Container(
              height: MediaQuery.of(context).size.height * 1.5,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (ResponsiveWidget.isMediumScreen(context) ||
                        ResponsiveWidget.isLargeScreen(context))
                      TopNavBar<PatientNavBarProvider>(
                        navItems: [...navItemsp],
                      ),
                    PatientHomeBody(),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          child: const Icon(Icons.chat),
          backgroundColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}
