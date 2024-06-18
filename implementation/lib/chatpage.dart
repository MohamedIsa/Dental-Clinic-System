import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final String otherUserId;
  final bool isAdmin;
  final bool isReceptionist;
  final bool isPatient;
  final String conversationId;

  ChatPage({
    required Key key,
    required this.user,
    required this.otherUserId,
    required this.isAdmin,
    required this.isReceptionist,
    required this.isPatient,
    required this.conversationId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<String> _getDisplayName(String userId) async {
  String displayName = '';

  // Check if the user is in the admin collection
  var adminSnapshot = await _firestore.collection('admin').doc(userId).get();
  if (adminSnapshot.exists) {
    displayName = 'Admin';
    return displayName;
  }

  // Check if the user is in the receptionist collection
  var receptionistSnapshot =
      await _firestore.collection('receptionist').doc(userId).get();
  if (receptionistSnapshot.exists) {
    displayName = 'Receptionist';
    return displayName;
  }

  // Check if the user is in the patient collection
  var patientSnapshot =
      await _firestore.collection('patient').doc(userId).get();
  if (patientSnapshot.exists) {
    // Retrieve the full name of the patient from the user collection
    var userSnapshot =
        await _firestore.collection('user').doc(userId).get();
    if (userSnapshot.exists) {
      displayName = userSnapshot.get('FullName');
    }
  } else {
    displayName = 'Unknown';
  }

  return displayName;
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      backgroundColor: Colors.blueGrey[600],
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .where('conversationId', isEqualTo: widget.conversationId)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages found.'),
                  );
                }

                var messages = snapshot.data?.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages!) {
                  final messageSender = message['sender'];
                  final messageText = message['text'];
                  final messageTime =
                      (message['timestamp'] as Timestamp).toDate();

                  final messageWidget = FutureBuilder<String>(
                    future: _getDisplayName(messageSender),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MessageBubble(
                          sender: snapshot.data ?? 'Unknown',
                          text: messageText,
                          time: messageTime,
                          isMe: widget.user.uid == messageSender,
                        );
                      }
                    },
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  children: messageWidgets,
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(widget.user.uid, widget.conversationId);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String senderId, String conversationId) async {
    String messageText = _messageController.text;

    _firestore.collection('messages').add({
      'text': messageText,
      'sender': senderId,
      'conversationId': conversationId,
      'timestamp': Timestamp.now(),
    });

    _messageController.clear();
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final DateTime time;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? 'You' : sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          SizedBox(height: 2),
          Text(
            DateFormat('HH:mm').format(time),
            style: TextStyle(fontSize: 10.0, color: Colors.grey),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
