import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../const/app_colors.dart';
import '../../const/bottomnavbar.dart';
import '../../const/navbaritems.dart';
import '../../const/topnavbar.dart';
import '../../functions/updateaccount/fetchdata.dart';
import '../../providers/patient_navbar.dart';
import '../../utils/data.dart';
import '../../utils/responsive_widget.dart';
import '../widgets/forms/updateaccountform.dart';
import '../widgets/static/patientappbar.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({super.key});

  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _cprController;
  late TextEditingController _dobController;
  late TextEditingController _selectedGender;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    Data.checkUserAndNavigate(context);
    _nameController = TextEditingController();
    _cprController = TextEditingController();
    _dobController = TextEditingController();
    _selectedGender = TextEditingController();
    _phoneController = TextEditingController();
    fetchUserData(_nameController, _cprController, _dobController,
        _selectedGender, _phoneController);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cprController.dispose();
    _dobController.dispose();
    _selectedGender.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Scaffold(
        appBar: PatientAppBar(),
        bottomNavigationBar: ResponsiveWidget.isSmallScreen(context)
            ? BottomNavBar<PatientNavBarProvider>(
                navItems: [...navItemsp],
              )
            : null,
        body: Container(
          height: MediaQuery.of(context).size.height * 1.5,
          decoration: const BoxDecoration(
            color: AppColors.backColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (ResponsiveWidget.isMediumScreen(context) ||
                    ResponsiveWidget.isLargeScreen(context))
                  TopNavBar<PatientNavBarProvider>(
                    navItems: [...navItemsp],
                  ),
                UpdateAccountForm(
                    nameController: _nameController,
                    cprController: _cprController,
                    dobController: _dobController,
                    selectedGender: _selectedGender,
                    phoneController: _phoneController)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
