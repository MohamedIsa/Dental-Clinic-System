import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> emailExists(String email) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    return false;
  }
}

Future<bool> cprExists(String cpr) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('cpr', isEqualTo: cpr)
        .get();
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    return false;
  }
}
