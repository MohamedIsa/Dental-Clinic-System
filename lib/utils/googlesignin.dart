import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: OauthCredential.clientId,
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
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
      bool userExists = await checkIfUserExistsInDatabase(firebaseUser.uid);
      if (userExists) {
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
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (userData.containsKey('FullName') &&
          userData.containsKey('CPR') &&
          userData.containsKey('Phone') &&
          userData.containsKey('Gender')) {
        return true;
      }
    }

    return false;
  } catch (e) {
    print("Error checking user existence: $e");
    return false;
  }
}
