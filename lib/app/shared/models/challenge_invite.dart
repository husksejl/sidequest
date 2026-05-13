import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeInvite {
  final String id;
  final String challengeTitle;
  final String challengeID;
  final String chatID;
  final String senderID;
  final String receiverID;
  final String status;
  final DateTime createdAt;

  const ChallengeInvite({
    required this.id,
    required this.challengeTitle,
    required this.challengeID,
    required this.chatID,
    required this.senderID,
    required this.receiverID,
    required this.status,
    required this.createdAt,
  });

  factory ChallengeInvite.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return ChallengeInvite(
      id: doc.id,
      challengeTitle: data['challengeTitle'] ?? '',
      challengeID: data['challengeID'] ?? '',
      chatID: data['chatID'] ?? '',
      senderID: data['senderID'] ?? '',
      receiverID: data['receiverID'] ?? '',
      status: data['status'] ?? '',
      createdAt: _timestampToDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'challengeTitle': challengeTitle,
      'challengeID': challengeID,
      'chatID': chatID,
      'senderID': senderID,
      'receiverID': receiverID,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }
}