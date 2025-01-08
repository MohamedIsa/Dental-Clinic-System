import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/models/chatmessage.dart';

Future<void> sendMessage(TextEditingController controller,
    CollectionReference chatCollection) async {
  final text = controller.text.trim();
  if (text.isEmpty) return;

  final newMessage = ChatMessage(
    senderId: FirebaseAuth.instance.currentUser!.uid,
    text: text,
    timestamp: DateTime.now(),
    seen: false,
  );

  await chatCollection.add(newMessage.toMap());
  controller.clear();
}
