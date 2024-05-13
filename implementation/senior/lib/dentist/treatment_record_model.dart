class TreatmentRecord {
  final String date;
  final String time;
  final String patientname;
  final String CPR;
  final String dentist;
  final String treatmentType;
  final String notes;
  final List<String> attachments;

  TreatmentRecord({
    required this.date,
    required this.time,
    required this.patientname,
    required this.dentist,
    required this.CPR,
    required this.treatmentType,
    required this.notes,
    required this.attachments,
  });
}
