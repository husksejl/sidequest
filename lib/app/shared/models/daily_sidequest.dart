import 'package:cloud_firestore/cloud_firestore.dart';

class DailySideQuest {
  final String id;
  final String title;
  final String description;
  final String date;
  final String difficulty;
  final DateTime createdAt;

  const DailySideQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.difficulty,
    required this.createdAt,
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
      difficulty: data['difficulty'] ?? '',
      createdAt: _timestampToDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'difficulty': difficulty,
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