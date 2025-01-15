import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';

Future<List<Map<String, dynamic>>> getDentists(BuildContext context) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> dentists = [];

  try {
    QuerySnapshot userSnapshot = await firestore
        .collection('users')
        .where('role', isEqualTo: 'dentist')
        .get();

    for (QueryDocumentSnapshot doc in userSnapshot.docs) {
      if (doc.exists &&
          doc.data() != null &&
          (doc.data() as Map<String, dynamic>).containsKey('name')) {
        String fullName = (doc.data() as Map<String, dynamic>)['name'];
        if (fullName.isNotEmpty) {
          List<String> nameParts = fullName.split(' ');
          String Name;
          if (nameParts.length >= 3) {
            Name = '${nameParts[0]} ${nameParts[1]}';
          } else {
            Name = fullName;
          }
          dentists.add({'id': doc.id, 'Name': Name});
        }
      }
    }
  } catch (e) {
    showErrorDialog(context, "Error: $e");
  }
  return dentists;
}
