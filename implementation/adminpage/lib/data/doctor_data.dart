import 'package:adminpage/models/doctor_model.dart';

class DoctorData {
  static List<Doctor> getDoctors() {
    // Implement logic to fetch doctors from API or local database
    return [
      Doctor(name: 'Dr. John Doe', patientCount: 20),
      Doctor(name: 'Dr. Jane Smith', patientCount: 15),
      // Add more doctors as needed
    ];
  }
}
