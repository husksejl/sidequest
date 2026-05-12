import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderID;
  final DateTime sentAt;
  final String text;

  const ChatMessage({
    required this.id,
    required this.senderID,
    required this.sentAt,
    required this.text,
  });

  factory ChatMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return ChatMessage(
      id: doc.id,
      senderID: data['senderID'] ?? '',
      sentAt: _timestampToDateTime(data['sentAt']),
      text: data['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'sentAt': Timestamp.fromDate(sentAt),
      'text': text,
    };
  }

  static DateTime _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }
}