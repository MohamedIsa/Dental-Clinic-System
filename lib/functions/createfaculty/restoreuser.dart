import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';

Future<void> restoreUser(BuildContext context, String userId) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('unavailable')
        .where('uid', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> userData = snapshot.docs.first.data();

      String? role = userData['role'];

      if (role == null) {
        throw Exception('Role not found for user');
      }

      Map<String, dynamic> newUserData = {'uid': userId};

      String targetCollection;
      switch (role.toLowerCase()) {
        case 'admin':
          targetCollection = 'admin';
          break;
        case 'dentist':
          targetCollection = 'dentist';
          break;
        case 'receptionist':
          targetCollection = 'receptionist';
          break;
        default:
          throw Exception('Invalid role specified');
      }

      await FirebaseFirestore.instance
          .collection(targetCollection)
          .doc(userId)
          .set(newUserData);

      await snapshot.docs.first.reference.delete();
      showMessagealert(context, 'User Restored Successfully');
    } else {
      throw Exception('User not found in unavailable collection');
    }
  } catch (e) {
    showErrorDialog(context, 'An error occurred: $e');
  }
}
