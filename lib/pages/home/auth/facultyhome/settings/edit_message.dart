import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';

class EditMessageScreen extends StatefulWidget {
  @override
  _EditWelcomeMessageScreenState createState() =>
      _EditWelcomeMessageScreenState();
}

class _EditWelcomeMessageScreenState extends State<EditMessageScreen> {
  final TextEditingController _welcomeMessageController =
      TextEditingController();
  String _currentWelcomeMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWelcomeMessage();
  }

  Future<void> _fetchWelcomeMessage() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('welcome')
          .doc('mgAMaIIGgWZTnNl0d32B')
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data.containsKey('message')) {
          final message = data['message'];
          if (message is String) {
            _updateWelcomeMessageText(message);
          } else {
            showErrorDialog(
                context, 'Welcome message is not a String: $message');
          }
        } else {
          showErrorDialog(
              context, 'Document does not contain a "message" field.');
        }
      } else {
        showErrorDialog(
            context, 'Document does not exist. Cannot fetch welcome message.');
      }
    } catch (e, stackTrace) {
      showErrorDialog(
          context, 'Error fetching welcome message: $e\n$stackTrace');
    }
  }

  void _updateWelcomeMessageText(String? message) {
    setState(() {
      _currentWelcomeMessage = message ?? '';
      _welcomeMessageController.text = _currentWelcomeMessage;
    });
  }

  Future<void> _updateWelcomeMessage(
      BuildContext context, String newMessage) async {
    try {
      await FirebaseFirestore.instance
          .collection('welcome')
          .doc('mgAMaIIGgWZTnNl0d32B')
          .set({'message': newMessage});
      showMessagealert(context, 'Welcome Message Updated Successfully');
    } catch (e) {
      showErrorDialog(context, 'Error updating welcome message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Welcome Message',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _welcomeMessageController,
              decoration: InputDecoration(
                labelText: 'Welcome Message',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateWelcomeMessage(context,
                    _welcomeMessageController.text); // Pass context here
              },
              child: Text(
                'Update Welcome Message',
                style: TextStyle(color: Colors.blue),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }
}
