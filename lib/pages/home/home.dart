import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/const/body.dart';
import '../../const/bottomnavbar.dart';
import '../../const/navbaritems.dart';
import '../../const/topnavbar.dart';
import '../../providers/home_navbar.dart';
import '../widgets/static/welcome_section.dart';
import '../widgets/static/services_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(context),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavBar<HomeNavBarProvider>(
              navItems: [...HomeNavItems],
            )
          : null,
      body: Container(
        height: MediaQuery.of(context).size.height * 1.5,
        decoration: const BoxDecoration(color: AppColors.primaryColor),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (MediaQuery.of(context).size.width > 600)
                TopNavBar<HomeNavBarProvider>(
                  navItems: [...HomeNavItems],
                ),
              Body(
                children: <Widget>[
                  WelcomeSection(
                      screenWidth: MediaQuery.of(context).size.width),
                  ServicesSection(
                      screenWidth: MediaQuery.of(context).size.width),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListTile(
      leading: Image.asset(
        'assets/images/logoh.png',
        width: width * 0.08,
        height: height * 0.08,
      ),
    );
  }
}
