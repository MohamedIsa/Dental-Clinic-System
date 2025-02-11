import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Data {
  static Future<String> apiUrl() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('api').get();
    String api = querySnapshot.docs.first.get('api');
    return api;
  }

  static String? currentID = FirebaseAuth.instance.currentUser!.uid;

  static Future<String> currentRole() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentID)
        .get();
    String role = documentSnapshot.get('role');
    return role;
  }

  static void checkUserAndNavigate(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }
  }

  static generateRandomID() {
    return Random().nextInt(1000000);
  }
}
