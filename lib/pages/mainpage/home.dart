import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/const/app_colors.dart';
import 'widgets/top_navigation_bar.dart';
import 'widgets/welcome_section.dart';
import 'widgets/services_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWelcomeMessage();
  }

  Future<void> fetchWelcomeMessage() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('welcome').limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          welcomeMessage = snapshot.docs.first['message'];
        });
      }
    } catch (error) {
      print('Error fetching welcome message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? _buildBottomNavigationBar(context)
          : null,
      body: Container(
        height: MediaQuery.of(context).size.height * 1.5,
        decoration: const BoxDecoration(color: Appcolors.primaryColor),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (MediaQuery.of(context).size.width > 600) TopNavigationBar(),
              Container(
                width: double.infinity,
                height: 1150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    WelcomeSection(
                        welcomeMessage: welcomeMessage,
                        screenWidth: MediaQuery.of(context).size.width),
                    ServicesSection(
                        screenWidth: MediaQuery.of(context).size.width),
                  ],
                ),
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
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/images/logoh.png',
          width: width * 0.08,
          height: height * 0.08,
        ),
      ],
    );
  }
}

BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Appcolors.primaryColor,
    selectedItemColor: Appcolors.primaryColor,
    unselectedItemColor: Appcolors.secondaryColor,
    selectedLabelStyle: const TextStyle(color: Colors.blue),
    showUnselectedLabels: true,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.info), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.login), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.app_registration), label: ''),
    ],
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/service');
          break;
        case 2:
          Navigator.pushNamed(context, '/aboutus');
          break;
        case 3:
          Navigator.pushNamed(context, '/login');
          break;
        case 4:
          Navigator.pushNamed(context, '/signup');
          break;
      }
    },
  );
}
