class Chat {
  String senderId;
  String text;
  DateTime timestamp;
  bool seen;
  String role;

  Chat(
      {required this.senderId,
      required this.text,
      required this.timestamp,
      this.seen = false,
      required this.role});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'seen': seen,
      'role': role,
    };
  }

  static Chat fromMap(Map<String, dynamic> map) {
    return Chat(
      senderId: map['senderId'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
      seen: map['seen'] ?? false,
      role: map['role'],
    );
  }
}
