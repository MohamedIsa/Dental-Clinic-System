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

  factory PatientData.fromMap(Map<String, dynamic> map) {
    return PatientData(
      fullName: map['FullName'] ?? '',
      cpr: map['CPR'] ?? '',
      birthDay: map['DOB'] ?? '',
      gender: map['Gender'] ?? '',
      phoneNumber: map['Phone'] ?? '',
      email: map['Email'] ?? '',
    );
  }
}