import 'package:cloud_firestore/cloud_firestore.dart';

class PatientData {
  final String id;
  final String fullName;
  final String cpr;
  final String birthDay;
  final String gender;
  final String phoneNumber;
  final String email;

  PatientData({
    required this.id,
    required this.fullName,
    required this.cpr,
    required this.birthDay,
    required this.gender,
    required this.phoneNumber,
    required this.email,
  });

  factory PatientData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PatientData(
      id: snapshot.id,
      fullName: data['FullName'],
      cpr: data['CPR'],
      birthDay: data['DOB'],
      gender: data['Gender'],
      phoneNumber: data['Phone'],
      email: data['Email'],
    );
  }
}
