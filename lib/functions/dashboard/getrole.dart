import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getRole() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (userDoc.exists) {
    return userDoc.data()?['role'];
  } else {
    return null;
  }
}
