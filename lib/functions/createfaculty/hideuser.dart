import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/popups.dart';

Future<void> hideUser(BuildContext context, String userId, String role) async {
  try {
    if (role.toLowerCase() == 'admin') {
      await FirebaseFirestore.instance.collection('admin').doc(userId).delete();
      await FirebaseFirestore.instance
          .collection('unavailable')
          .doc(userId)
          .set({'uid': userId, 'role': 'admin'});
    } else if (role.toLowerCase() == 'dentist') {
      await FirebaseFirestore.instance
          .collection('dentist')
          .doc(userId)
          .delete();
      await FirebaseFirestore.instance
          .collection('unavailable')
          .doc(userId)
          .set({'uid': userId, 'role': 'dentist'});
    } else if (role.toLowerCase() == 'receptionist') {
      await FirebaseFirestore.instance
          .collection('receptionist')
          .doc(userId)
          .delete();
      await FirebaseFirestore.instance
          .collection('unavailable')
          .doc(userId)
          .set({'uid': userId, 'role': 'receptionist'});
    }
    showMessagealert(context, 'User Hidden Successfully');
  } catch (e) {
    print('Error: $e');
    showErrorDialog(context, e.toString());
  }
}
