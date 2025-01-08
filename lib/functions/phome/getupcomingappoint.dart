Future<String> getUpcomingAppointment(String uid) async {
  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //     .collection('appointments')
  //     .where('uid', isEqualTo: uid)
  //     .orderBy('date')
  //     .get();

  // if (querySnapshot.docs.isNotEmpty) {
  //   DateTime now = DateTime.now();

  //   int startHour = 9;
  //   int endHour = 17;

  //   for (DocumentSnapshot appointment in querySnapshot.docs) {
  //     DateTime appointmentDate =
  //         (appointment.get('date') as Timestamp).toDate();

  //     dynamic hourValue = appointment['hour'];
  //     int appointmentHour;
  //     if (hourValue is int) {
  //       appointmentHour = hourValue;
  //     } else if (hourValue is String) {
  //       appointmentHour = int.parse(hourValue);
  //     } else {
  //       appointmentHour = 0;
  //     }

  //     DateTime appointmentTime = DateTime(
  //       appointmentDate.year,
  //       appointmentDate.month,
  //       appointmentDate.day,
  //       appointmentHour,
  //     );

  //     if (appointmentHour >= startHour &&
  //         appointmentHour <= endHour &&
  //         appointmentTime.isAfter(now)) {
  //       String dentistId = appointment['did'] ?? '';
  //       DocumentSnapshot dentistDoc = await FirebaseFirestore.instance
  //           .collection('user')
  //           .doc(dentistId)
  //           .get();
  //       String dentist = dentistDoc.get('FullName') ?? '';
  //       String dentistfirst = dentist.split(' ').first;
  //       String formattedDate = DateFormat('yyyy-MM-dd').format(appointmentDate);
  //       String formattedAppointment =
  //           '\nDate: $formattedDate\nDentist: Dr.$dentistfirst,\nTime: ${appointmentHour.toString()}:00';
  //       print(formattedAppointment);
  //       return formattedAppointment;
  //     }
  //   }
  // }

  // return 'No upcoming appointments';
  return 'No upcoming appointments';
}
