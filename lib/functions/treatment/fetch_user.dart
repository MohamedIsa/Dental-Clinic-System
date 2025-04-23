import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchPatientId(String cpr) async {
  final result = await FirebaseFirestore.instance
      .collection('users')
      .where('cpr', isEqualTo: cpr)
      .where('role', isEqualTo: 'patient')
      .get();

  if (result.docs.isNotEmpty) {
    return result.docs.first.id;
  } else {
    throw Exception('Patient not found');
  }
}
