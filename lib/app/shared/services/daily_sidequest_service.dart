import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_sidequest.dart';

class DailySideQuestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _dailySideQuestCollection {
    return _firestore.collection('daily_sidequest');
  }

  Future<void> createDailySideQuest({
    required String title,
    required String description,
    required String date,
    required String difficulty,
  }) async {
    final sideQuest = DailySideQuest(
      id: '',
      title: title,
      description: description,
      date: date,
      difficulty: difficulty,
      createdAt: DateTime.now(),
    );

    await _dailySideQuestCollection.add(sideQuest.toMap());
  }

  Future<DailySideQuest?> getDailySideQuestByDate(String date) async {
    final querySnapshot = await _dailySideQuestCollection
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return DailySideQuest.fromFirestore(querySnapshot.docs.first);
  }

  Stream<DailySideQuest?> watchDailySideQuestByDate(String date) {
    return _dailySideQuestCollection
        .where('date', isEqualTo: date)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return DailySideQuest.fromFirestore(querySnapshot.docs.first);
    });
  }

  Stream<List<DailySideQuest>> watchAllDailySideQuests() {
    return _dailySideQuestCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return DailySideQuest.fromFirestore(doc);
      }).toList();
    });
  }
}