class Appointments {
  final String id;
  final String date;
  final String time;
  final String patientId;
  final String dentistId;

  const Appointments({
    required this.id,
    required this.date,
    required this.time,
    required this.patientId,
    required this.dentistId,
  });

  factory Appointments.fromFirestore(String id, Map<String, dynamic> data) {
    return Appointments(
      id: id,
      date: data['date'],
      time: data['time'],
      patientId: data['patientId'],
      dentistId: data['dentistId'],
    );
  }
}
