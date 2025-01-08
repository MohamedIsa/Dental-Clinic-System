class ChatMessage {
  String senderId;
  String text;
  DateTime timestamp;
  bool seen;

  ChatMessage({
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.seen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'seen': seen,
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
      seen: map['seen'] ?? false,
    );
  }
}
