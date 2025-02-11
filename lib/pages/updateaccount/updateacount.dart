import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../const/app_colors.dart';
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
  late String _selectedGender;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    Data.checkUserAndNavigate(context);

    // Initialize controllers
    _nameController = TextEditingController();
    _cprController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _selectedGender = '';

    fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cprController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _nameController.text = snapshot['name'] ?? '';
        _cprController.text = snapshot['cpr'] ?? '';
        _dobController.text = snapshot['dob'] ?? '';
        _selectedGender = snapshot['gender'] ?? '';
        _phoneController.text = snapshot['phone'] ?? '';
      });
    }
  }

  void _onGenderChanged(String newGender) {
    setState(() {
      _selectedGender = newGender;
    });
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
              onGenderChanged: _onGenderChanged,
            ),
          ),
        ),
      ),
    );
  }
}
