import 'package:adminpage/models/clinic_details_model.dart';
class ClinicDetails {
  final clinicadata = const [
    DetailsModel(
        icon: 'assets/icons/patient_icon.png', value: "50", title: "New Patient"),
    DetailsModel(
        icon: 'assets/icons/doctor_dental_icon.png', value: "5", title: "Doctor Avilaible"),
    DetailsModel(
        icon: 'assets/icons/people_group_icon.png', value: "10", title: "Today Appointments"),
  ];
}
