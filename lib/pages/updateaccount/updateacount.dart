import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../const/app_colors.dart';
import '../../functions/updateaccount/fetchdata.dart';
import '../../utils/data.dart';
import '../widgets/forms/updateaccountform.dart';

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Update Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: UpdateAccountForm(
              nameController: _nameController,
              cprController: _cprController,
              dobController: _dobController,
              selectedGender: _selectedGender,
              phoneController: _phoneController,
            ),
          ),
        ),
      ),
    );
  }
}
