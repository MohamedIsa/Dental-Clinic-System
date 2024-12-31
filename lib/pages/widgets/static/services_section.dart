import 'package:flutter/material.dart';
import 'package:senior/const/servicelist.dart';
import '../../const/service_card.dart';

class ServicesSection extends StatelessWidget {
  final double screenWidth;

  const ServicesSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          border:
              Border.fromBorderSide(BorderSide(color: Colors.blue, width: 2)),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        margin: EdgeInsets.only(top: screenWidth <= 600 ? 350 : 300),
        height: screenWidth <= 600 ? 755 : 520,
        width: screenWidth <= 600 ? 300 : 1000,
        child: Column(
          children: [
            Text(
              'Our Services',
              style: TextStyle(
                  color: Colors.white, fontSize: screenWidth <= 600 ? 20 : 30),
            ),
            const SizedBox(height: 20),
            _buildServiceRows(context),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRows(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 600;
    final int servicesPerRow = isMobile ? 2 : 4;
    final double spacing = isMobile ? 20 : 90;

    List<Widget> serviceRows = [];
    for (int i = 0; i < ServiceList.services.length; i += servicesPerRow) {
      List<Widget> rowServices = [];
      for (int j = 0; j < servicesPerRow; j++) {
        if (i + j < ServiceList.services.length) {
          rowServices.add(_buildServiceCard(i + j));
        }
      }
      serviceRows.add(_buildServiceRow(rowServices));
      if (i + servicesPerRow < ServiceList.services.length) {
        serviceRows.add(SizedBox(height: spacing));
      }
    }

    return Column(children: serviceRows);
  }

  Row _buildServiceRow(List<Widget> services) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: services,
    );
  }

  ServiceCard _buildServiceCard(int index) {
    return ServiceCard(
      title: ServiceList.services[index]['title'] ?? '',
      imagePath: ServiceList.services[index]['imagePath'] ?? '',
      description: ServiceList.services[index]['description'] ?? '',
    );
  }
}
