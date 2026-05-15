import 'package:cloud_firestore/cloud_firestore.dart';

class DailySideQuest {
  final String id;
  final String title;
  final String description;
  final String date;
  final String difficulty;
  final int xp;
  final DateTime createdAt;
  final String sourceQuestID;

  const DailySideQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.difficulty,
    required this.xp,
    required this.createdAt,
    required this.sourceQuestID,
  });

  factory DailySideQuest.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return DailySideQuest(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      difficulty: data['difficulty'] ?? 'easy',
      xp: _toInt(data['xp']),
      createdAt: _timestampToDateTime(data['createdAt']),
      sourceQuestID: data['sourceQuestID'] ?? doc.id,
    );
  }

  static DateTime _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}