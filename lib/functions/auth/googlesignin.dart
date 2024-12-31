import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior/utils/popups.dart';
import '../../firebase_options.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId ??
          OauthCredential.clientId,
    );

    GoogleSignInAccount? googleUser;

    if (kIsWeb) {
      googleUser = await googleSignIn.signIn();
    } else {
      await googleSignIn.signOut();
      googleUser = await googleSignIn.signIn();
    }

    if (googleUser == null) {
      if (context.mounted) {
        showErrorDialog(context, 'Google Sign-In cancelled');
      }
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (context.mounted) {
      await handleFirebaseSignIn(context, credential);
    }
  } catch (e) {
    if (context.mounted) {
      showErrorDialog(context, 'An unexpected error occurred: ${e.toString()}');
    }
    debugPrint("Sign-In error: $e");
  }
}

Future<void> handleFirebaseSignIn(
    BuildContext context, AuthCredential credential) async {
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      bool userExists = await checkIfUserExistsInDatabase(firebaseUser.uid);

      if (context.mounted) {
        if (userExists) {
          Navigator.pushReplacementNamed(context, '/patientDashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/complete');
        }
      }
    } else {
      if (context.mounted) {
        showErrorDialog(context, 'Authentication failed');
      }
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'Authentication error';
    switch (e.code) {
      case 'account-exists-with-different-credential':
        errorMessage = 'An account already exists with a different credential';
        break;
      case 'invalid-credential':
        errorMessage = 'Invalid login credentials';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Google Sign-In is not enabled';
        break;
      default:
        errorMessage = 'An unknown error occurred';
    }
    if (context.mounted) {
      showErrorDialog(context, errorMessage);
    }
  }
}

Future<bool> checkIfUserExistsInDatabase(String uid) async {
  try {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      return userData != null &&
          userData.containsKey('name') &&
          userData.containsKey('cpr') &&
          userData.containsKey('phone') &&
          userData.containsKey('gender');
    }

    return false;
  } catch (e) {
    debugPrint("Error checking user existence: $e");
    return false;
  }
}
