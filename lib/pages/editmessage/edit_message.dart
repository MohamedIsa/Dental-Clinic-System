import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/functions/editmessage/editmessag.dart';

class EditMessageScreen extends StatefulWidget {
  const EditMessageScreen({super.key});

  @override
  _EditWelcomeMessageScreenState createState() =>
      _EditWelcomeMessageScreenState();
}

class _EditWelcomeMessageScreenState extends State<EditMessageScreen> {
  final TextEditingController welcomeMessageController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    getMessage().then((message) {
      if (message != null) {
        welcomeMessageController.text = message;
      }
    });
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
        iconTheme: IconThemeData(color: AppColors.whiteColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: welcomeMessageController,
              decoration: InputDecoration(
                labelText: 'Welcome Message',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => updateMessage(
                context,
                welcomeMessageController.text,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: Text(
                'Update Welcome Message',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }
}
