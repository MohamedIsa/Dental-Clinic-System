import 'package:adminpage/data/clinic_details.dart';
import 'package:adminpage/screens/main_screen/widget/custom_card_widget.dart';
import 'package:flutter/material.dart';

class ClinicDetailsCard extends StatelessWidget {
  const ClinicDetailsCard({Key? key});

  @override
  Widget build(BuildContext context) {
    final clinicDetails = ClinicDetails();

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: clinicDetails.clinicadata.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    clinicDetails.clinicadata[index].value,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  clinicDetails.clinicadata[index].title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight, // Align the image to the bottom right
                  child: Image.asset(
                    clinicDetails.clinicadata[index].icon,
                    width: 180,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
