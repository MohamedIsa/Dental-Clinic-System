import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserRole(String userId) async {
  String? role;

  var adminDoc =
      await FirebaseFirestore.instance.collection('admin').doc(userId).get();
  if (adminDoc.exists) {
    role = 'Admin';
  } else {
    var dentistDoc = await FirebaseFirestore.instance
        .collection('dentist')
        .doc(userId)
        .get();
    if (dentistDoc.exists) {
      role = 'Dentist';
    } else {
      var receptionistDoc = await FirebaseFirestore.instance
          .collection('receptionist')
          .doc(userId)
          .get();
      if (receptionistDoc.exists) {
        role = 'Receptionist';
      } else {
        var unavailableDoc = await FirebaseFirestore.instance
            .collection('unavailable')
            .doc(userId)
            .get();
        if (unavailableDoc.exists) {
          role = 'Unavailable';
        } else {
          role = null;
        }
      }
    }
  }

  return role;
}
