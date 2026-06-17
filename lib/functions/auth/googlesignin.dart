import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior/utils/popups.dart';
import '../../firebase_options.dart';

bool _isGoogleSignInInitialized = false;

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    if (kIsWeb) {
      final userCredential = await FirebaseAuth.instance.signInWithPopup(
        GoogleAuthProvider(),
      );

      if (context.mounted) {
        await handleFirebaseSignInResult(context, userCredential);
      }
      return;
    }

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    if (!_isGoogleSignInInitialized) {
      await googleSignIn.initialize(
        clientId: DefaultFirebaseOptions.iosClientId.isEmpty
            ? null
            : DefaultFirebaseOptions.iosClientId,
      );
      _isGoogleSignInInitialized = true;
    }

    await googleSignIn.signOut();
    if (!googleSignIn.supportsAuthenticate()) {
      showErrorDialog(context, 'Google Sign-In is not supported here');
      return;
    }

    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    if (context.mounted) {
      await handleFirebaseSignIn(context, credential);
    }
  } on GoogleSignInException catch (e) {
    if (e.code != GoogleSignInExceptionCode.canceled && context.mounted) {
      showErrorDialog(context, 'Google Sign-In failed: ${e.description}');
    }
  } catch (e) {
    if (e is FirebaseAuthException &&
        e.code != 'popup_closed' &&
        e.message != 'Popup window closed') {
      showErrorDialog(context, 'An unexpected error occurred: ${e.toString()}');
    }
  }
}

Future<void> handleFirebaseSignIn(
  BuildContext context,
  AuthCredential credential,
) async {
  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    await handleFirebaseSignInResult(context, userCredential);
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
    showErrorDialog(context, errorMessage);
  }
}

Future<void> handleFirebaseSignInResult(
  BuildContext context,
  UserCredential userCredential,
) async {
  final User? firebaseUser = userCredential.user;

  if (firebaseUser != null) {
    bool userExists = await checkIfUserExistsInDatabase(firebaseUser.uid);

    if (context.mounted) {
      if (userExists) {
        context.go('/patientDashboard');
      } else {
        context.go('/complete');
      }
    }
  } else {
    if (context.mounted) {
      showErrorDialog(context, 'Authentication failed');
    }
  }
}

Future<bool> checkIfUserExistsInDatabase(String uid) async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

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
    return false;
  }
}
