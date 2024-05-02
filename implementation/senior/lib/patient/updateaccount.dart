import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:senior/app_colors.dart';
import 'package:senior/app_icons.dart';
import 'package:senior/app_styles.dart';
import 'package:senior/reuseable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior/responsive_widget.dart';

class UpdateAccountPage extends StatefulWidget {
  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  int _selectedIndex = 3;
  late TextEditingController _nameController;
  late TextEditingController _cprController;
  late TextEditingController _dobController;
  late TextEditingController _selectedGender;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _cprController = TextEditingController();
    _dobController = TextEditingController();
    _selectedGender = TextEditingController();
    _phoneController = TextEditingController();
    fetchUserData();
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

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      setState(() {
        _nameController.text = snapshot['FullName'] ?? '';
        _cprController.text = snapshot['CPR'] ?? '';
        _dobController.text = snapshot['DOB'] ?? '';
        _selectedGender.text = snapshot['Gender'] ?? '';
        _phoneController.text = snapshot['Phone'] ?? '';
      });
    }
  }

  void updateUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'FullName': _nameController.text,
        'CPR': _cprController.text,
        'DOB': _dobController.text,
        'Gender': _selectedGender.text,
        'Phone': _phoneController.text,
      });
       Navigator.pushNamed(context, '/dashboard');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User updated successfully'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String CPRPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
    String PhonePattern = r'^(66\d{6}|3[2-9]\d{6})$';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Account',
          style: ralewayStyle.copyWith(
            color: Colors.blue,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: ResponsiveWidget.isSmallScreen(context)
          ? BottomNavigationBar(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle: TextStyle(color: Colors.grey),
              selectedLabelStyle: TextStyle(color: Colors.blue),
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_today,
                  ),
                  label: 'Book Appointment',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history,
                  ),
                  label: 'Appointment History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'Update Account',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.edit,
                  ),
                  label: 'Edit Appointment',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/dashboard');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/bookingm');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/appointmenthistory');
                    break;
                  case 3:
                    break;
                  case 4:
                    break;
                }
              },
            )
          : null,
      body: Container(
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (ResponsiveWidget.isMediumScreen(context) ||
                  ResponsiveWidget.isLargeScreen(context))
                Container(
                  color: Colors.blue,
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/dashboard');
                            },
                            child: const Text(
                              'Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/booking');
                            },
                            child: const Text(
                              'Book Appointment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/appointmenthistory');
                            },
                            child: const Text(
                              'Appointment History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Update Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Edit Appointment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns children to the left
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Full Name',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField('Enter Full Name',
                            AppIcons.userIcon, false, _nameController),
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'CPR',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField(
                            'Enter CPR', AppIcons.idicon, false, _cprController),
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Date of Birth',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: ReusableTextField('Ente Date of Birth',
                              AppIcons.birthIcon, false, _dobController)),
                      SizedBox(height: height * 0.014),
                      Text(
                        'Gender',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: _selectedGender.text,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender.text = value.toString();
                              });
                            },
                          ),
                          Text('Male'),
                          SizedBox(
                            width: width * 0.014,
                          ),
                          Radio(
                            value: 'Female',
                            groupValue: _selectedGender.text,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender.text = value.toString();
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Phone Number',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: ReusableTextField('Enter Your phone number',
                              AppIcons.phoneIcon, false, _phoneController)),
                      SizedBox(height: height * 0.014),
                      SizedBox(height: 20),
                      Center(
                      child:ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty ||
                              _cprController.text.isEmpty ||
                              _dobController.text.isEmpty ||
                              _selectedGender.text.isEmpty ||
                              _phoneController.text.isEmpty) {
                            showErrorDialog(context, 'Please fill all fields.');
                            return;
                          }
                          if (_cprController.text.length != 9) {
                            showErrorDialog(context, 'CPR must be 9 digits.');
                            return;
                          }
                
                          CollectionReference users =
                              FirebaseFirestore.instance.collection('user');
                
                          var queryResult = await users
                              .where('CPR', isEqualTo: _cprController.text)
                              .get();
                
                          // Check if CPR already exists and it's different from the original CPR
                          if (queryResult.docs.isNotEmpty &&
                              queryResult.docs.first['CPR'] !=
                                  _cprController.text) {
                            showErrorDialog(context, 'CPR already exists.');
                            return;
                          }
                
                          if (!RegExp(PhonePattern)
                              .hasMatch(_phoneController.text)) {
                            showErrorDialog(context, 'Invalid Phone format.');
                            return;
                          }
                
                          if (!RegExp(CPRPattern).hasMatch(_cprController.text)) {
                            showErrorDialog(context, 'Invalid CPR format.');
                            return;
                          }
                
                          updateUser();
                        },
                        child: Text('Update'
                        , style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,)
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),
                  )],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
