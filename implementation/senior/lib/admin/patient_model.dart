import 'package:cloud_firestore/cloud_firestore.dart';

class PatientData {
  final String fullName;
  final String cpr;
  final String birthDay;
  final String gender;
  final String phoneNumber;
  final String email;

  PatientData({
    required this.fullName,
    required this.cpr,
    required this.birthDay,
    required this.gender,
    required this.phoneNumber,
    required this.email,
  });

  static PatientData fromSnapshot(DocumentSnapshot patientSnapshot) {
    Map<String, dynamic> data = patientSnapshot.data() as Map<String, dynamic>;
    return PatientData(
      fullName: data['name'] ?? '',
      cpr: data['cpr'] ?? '',
      birthDay: data['birthDay'] ?? '',
      gender: data['gender'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
    );
  }
}