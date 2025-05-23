import 'package:flutter/material.dart';
import 'package:senior/functions/phome/getupcomingappoint.dart';
import '../../../const/app_colors.dart';
import '../../../const/body.dart';
import '../../../const/messagecontainer.dart';
import '../../../utils/data.dart';

class PatientHomeBody extends StatefulWidget {
  const PatientHomeBody({super.key});

  @override
  State<PatientHomeBody> createState() => _PatientHomeBodyState();
}

class _PatientHomeBodyState extends State<PatientHomeBody> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    return Body(children: <Widget>[
      MessageContainer(
        futureMessage: getUpcomingAppointment(Data.currentID!),
        containerWidth: isMobile ? null : 430,
        containerHeight: isMobile ? 130 : 200,
        margin: const EdgeInsets.only(top: 100, bottom: 800),
        backgroundColor: AppColors.primaryColor,
      ),
    ]);
  }
}
