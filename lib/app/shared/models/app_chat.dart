import 'package:cloud_firestore/cloud_firestore.dart';

class AppChat {
  final String id;
  final String lastMessage;
  final List<String> memberIDs;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppChat({
    required this.id,
    required this.lastMessage,
    required this.memberIDs,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppChat.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return AppChat(
      id: doc.id,
      lastMessage: data['lastMessage'] ?? '',
      memberIDs: List<String>.from(data['memberIDs'] ?? []),
      type: data['type'] ?? 'dm',
      createdAt: _timestampToDateTime(data['createdAt']),
      updatedAt: _timestampToDateTime(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'memberIDs': memberIDs,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static DateTime _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }
}