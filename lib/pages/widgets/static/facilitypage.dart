import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../../utils/responsive_widget.dart';

import '../../../../providers/side_menu_provider.dart';

import '../headers/header_widget.dart';
import '../navigations/side_menu_widget.dart';
import 'mobileview.dart';

class FacilityPage extends StatelessWidget {
  final Widget? widget;
  final Widget? widget1;

  const FacilityPage({super.key, required this.widget, required this.widget1});

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider =
        Provider.of<SideMenuProvider>(context, listen: false);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).get();

    bool isWeb = kIsWeb && ResponsiveWidget.isLargeScreen(context);

    return FutureBuilder(
      future: sideMenuProvider.loadMenu(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCube(
            size: 30,
            color: Colors.blue,
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return isWeb
              ? StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final fullName = snapshot.data?.get('name') ?? '';
                      final firstName = fullName.split(' ')[0];

                      return Scaffold(
                        appBar: HeaderWidget(userName: firstName),
                        body: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SideMenuWidget(),
                                    ),
                                    widget ?? SizedBox.shrink(),
                                    widget1 ?? SizedBox.shrink()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SpinKitFadingCube(
                        size: 30,
                        color: Colors.blue,
                      );
                    }
                  },
                )
              : MobileView();
        }
      },
    );
  }
}
