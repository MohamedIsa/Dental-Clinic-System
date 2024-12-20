import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:senior/const/navbaritems.dart';
import 'package:senior/const/bottomnavbar.dart';
import 'package:senior/pages/phome/widgets/patientappbar.dart';
import 'package:senior/pages/phome/widgets/patienthomebody.dart';
import 'package:senior/const/topnavbar.dart';
import '../../utils/responsive_widget.dart';
import 'functions/getusername.dart';

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
            ? BottomNavBar(
                navItems: [...navItemsp],
              )
            : null,
        body: FutureBuilder<String>(
          future: getFullName(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCube(
                  color: Colors.blue,
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Container(
              height: MediaQuery.of(context).size.height * 1.5,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (ResponsiveWidget.isMediumScreen(context) ||
                        ResponsiveWidget.isLargeScreen(context))
                      TopNavBar(
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
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
