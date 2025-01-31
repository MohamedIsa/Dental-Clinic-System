import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:senior/const/navbaritems.dart';
import 'package:senior/const/bottomnavbar.dart';
import 'package:senior/pages/widgets/static/patientappbar.dart';
import 'package:senior/pages/widgets/static/patienthomebody.dart';
import 'package:senior/const/topnavbar.dart';
import 'package:senior/utils/data.dart';
import '../../const/app_colors.dart';
import '../../functions/chat/seenmessage.dart';
import '../../providers/patient_navbar.dart';
import '../../utils/responsive_widget.dart';
import '../../functions/phome/getusername.dart';
import '../chat/chatpage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Future<bool> isSeenFuture;

  @override
  void initState() {
    super.initState();
    final patientId = Data.currentID;
    isSeenFuture = isMessageSeen(
        FirebaseFirestore.instance
            .collection('users')
            .doc(patientId)
            .collection('chat'),
        Data.currentID);
  }

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
        floatingActionButton: FutureBuilder<bool>(
          future: isSeenFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return FloatingActionButton(
                onPressed: null,
                backgroundColor: AppColors.primaryColor,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            final bool isSeen = snapshot.data ?? false;

            return FloatingActionButton(
              onPressed: () async {
                final patientId = FirebaseAuth.instance.currentUser?.uid;

                if (patientId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        senderId: patientId,
                        patientId: patientId,
                      ),
                    ),
                  );
                }
              },
              backgroundColor: AppColors.primaryColor,
              child: isSeen
                  ? Badge(
                      label: const Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 2.0,
                      ),
                      child: const Icon(Icons.chat),
                    )
                  : const Icon(Icons.chat),
            );
          },
        ),
      ),
    );
  }
}
