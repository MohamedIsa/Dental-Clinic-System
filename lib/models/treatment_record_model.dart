import 'package:cloud_firestore/cloud_firestore.dart';

class TreatmentRecord {
  final String treatmentId;
  final String date;
  final String time;
  final String patientId;
  final String dentistId;
  final String cpr;
  final String treatmentType;
  final String notes;
  final String? attachment;

  TreatmentRecord({
    required this.treatmentId,
    required this.date,
    required this.time,
    required this.patientId,
    required this.dentistId,
    required this.cpr,
    required this.treatmentType,
    required this.notes,
    this.attachment,
  });
  Map<String, dynamic> toJson() {
    return {
      'treatmentId': treatmentId,
      'date': date,
      'time': time,
      'patientId': patientId,
      'dentistId': dentistId,
      'cpr': cpr,
      'treatmentType': treatmentType,
      'notes': notes,
      'attachment': attachment,
    };
  }

  factory TreatmentRecord.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return TreatmentRecord(
      treatmentId: doc.id,
      date: doc['date'],
      time: doc['time'],
      patientId: doc['patientId'],
      dentistId: doc['dentistId'],
      cpr: doc['cpr'],
      treatmentType: doc['treatmentType'],
      notes: doc['notes'],
      attachment: doc['attachment'],
    );
  }
}
