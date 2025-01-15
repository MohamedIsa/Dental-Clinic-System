import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserRole(String userId) async {
  var userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (userDoc.exists) {
    return userDoc.data()?['role'];
  } else {
    return null;
  }
}
