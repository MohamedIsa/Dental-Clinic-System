import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> emailExists(String email) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  return querySnapshot.docs.isNotEmpty;
}

Future<bool> cprExists(String cpr) async {
  print('Checking if CPR exists: $cpr');
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('cpr', isEqualTo: cpr)
      .get();
  final exists = querySnapshot.docs.isNotEmpty;
  print(exists ? 'CPR exists' : 'CPR does not exist');
  return exists;
}
