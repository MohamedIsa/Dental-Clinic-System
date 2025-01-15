import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';

Future<String?> getMessage() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('messages').limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['message'];
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<void> updateMessage(
  BuildContext context,
  String message,
) async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('messages').limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({'message': message});
    } else {
      await FirebaseFirestore.instance.collection('messages').add({
        'message': message,
      });
    }
    showMessagealert(context, 'Message added successfully');
    Navigator.of(context).pop();
  } catch (e) {
    showErrorDialog(context, 'Error updating message: $e');
  }
}
