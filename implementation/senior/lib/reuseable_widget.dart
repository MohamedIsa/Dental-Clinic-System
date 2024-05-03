import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;


class ReusableTextField extends StatefulWidget {
  final String hintText;
  final String iconAssetPath;
  final bool isPassword;
  final TextEditingController controller;

  ReusableTextField(this.hintText, this.iconAssetPath, this.isPassword, this.controller);

  @override
  _ReusableTextFieldState createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontSize: 12.0,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: widget.iconAssetPath.isNotEmpty
            ? ImageIcon(AssetImage(widget.iconAssetPath))
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              )
            : null,
        contentPadding: EdgeInsets.only(top: 16.0),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.5),
          fontSize: 12.0,
        ),
      ),
    );
  }
}


void showErrorDialog(BuildContext context, String message) {
  if (kIsWeb) {
    html.window.alert(message);
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kIsWeb ? 0 : 15),
          ),
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                iconColor: kIsWeb ? Colors.blue : Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "351146855860-pejmdc7vsc20tqrf2t23g05aipm9i6to.apps.googleusercontent.com",
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // Handle case where Google sign-in was cancelled
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User? firebaseUser = userCredential.user;
    if (firebaseUser != null) {
      // Check if user exists in Firestore database
      bool userExists = await checkIfUserExistsInDatabase(firebaseUser.uid);
      if (userExists) {
        // User exists in database, navigate to welcome page
        Navigator.pushReplacementNamed(context, '/dashboard');  
      } else {
        Navigator.pushReplacementNamed(context, '/completedetails');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
Future<bool> checkIfUserExistsInDatabase(String uid) async {
  try {
    // Get a reference to the user document
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    // Check if the user document exists and contains necessary details
    if (userSnapshot.exists) {
      // Get data from the document
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      // Check if the user document contains all necessary fields
      if (userData.containsKey('FullName') &&
          userData.containsKey('CPR') &&
          userData.containsKey('Phone') &&
          userData.containsKey('Gender')) {
        // User document contains all necessary details
        return true;
      }
    }

    // User document does not exist or does not contain all necessary details
    return false;
  } catch (e) {
    print("Error checking user existence: $e");
    return false; // Assume user does not exist in case of error
  }
}
