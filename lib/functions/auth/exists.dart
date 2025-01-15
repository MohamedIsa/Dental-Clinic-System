import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> emailExists(String email) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  return querySnapshot.docs.isNotEmpty;
}

Future<bool> cprExists(String cpr) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('cpr', isEqualTo: cpr)
      .get();
  final exists = querySnapshot.docs.isNotEmpty;
  return exists;
}
