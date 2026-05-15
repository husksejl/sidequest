import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_sidequest.dart';

class DailySideQuestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _dailySideQuestCollection {
    return _firestore.collection('daily_sidequest');
  }

  CollectionReference<Map<String, dynamic>> get _completedSideQuestCollection {
    return _firestore.collection('completed_sidequest');
  }

  CollectionReference<Map<String, dynamic>> get _usersCollection {
    return _firestore.collection('users');
  }

  String getTodayDate() {
    return _formatDate(DateTime.now());
  }

  Future<DailySideQuest?> getOrCreateTodayDailySideQuest() async {
    final today = getTodayDate();

    final existingTodayQuest = await getDailySideQuestByDate(today);

    if (existingTodayQuest != null) {
      return existingTodayQuest;
    }

    return _createNewDailySideQuestForDate(today);
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

  Stream<DailySideQuest?> watchTodayDailySideQuest() {
    final today = getTodayDate();

    return watchDailySideQuestByDate(today);
  }

  Stream<bool> watchIsDailySideQuestCompleted({
    required String userID,
    required String sideQuestID,
    required String date,
  }) {
    final completedID = _completedSideQuestID(
      userID: userID,
      sideQuestID: sideQuestID,
      date: date,
    );

    return _completedSideQuestCollection.doc(completedID).snapshots().map(
          (doc) {
        return doc.exists;
      },
    );
  }

  Future<void> completeDailySideQuestFromUpload({
    required String userID,
    required String sideQuestID,
    required String date,
    required int xp,
    required String mediaType,
    required String mediaPath,
    String? caption,
  }) async {
    final completedID = _completedSideQuestID(
      userID: userID,
      sideQuestID: sideQuestID,
      date: date,
    );

    final completedRef = _completedSideQuestCollection.doc(completedID);
    final userRef = _usersCollection.doc(userID);

    await _firestore.runTransaction((transaction) async {
      final completedSnapshot = await transaction.get(completedRef);

      if (completedSnapshot.exists) {
        return;
      }

      transaction.set(completedRef, {
        'userID': userID,
        'sideQuestID': sideQuestID,
        'date': date,
        'completedAt': FieldValue.serverTimestamp(),
        'xpEarned': xp,
        'mediaType': mediaType,
        'mediaPath': mediaPath,
        'caption': caption ?? '',
      });

      transaction.set(
        userRef,
        {
          'xp': FieldValue.increment(xp),
        },
        SetOptions(merge: true),
      );
    });
  }

  Future<DailySideQuest?> _createNewDailySideQuestForDate(String date) async {
    final allQuestsSnapshot = await _dailySideQuestCollection.get();

    if (allQuestsSnapshot.docs.isEmpty) {
      return null;
    }

    final allDocs = allQuestsSnapshot.docs;

    final explicitTemplates = allDocs.where((doc) {
      final data = doc.data();

      return data['isTemplate'] == true;
    }).toList();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> pool;

    if (explicitTemplates.isNotEmpty) {
      pool = explicitTemplates;
    } else {
      pool = allDocs.where((doc) {
        final data = doc.data();

        if (data['isTemplate'] == false) {
          return false;
        }

        if (doc.id.startsWith('daily_')) {
          return false;
        }

        return true;
      }).toList();
    }

    if (pool.isEmpty) {
      return null;
    }

    final yesterdayQuest = await getDailySideQuestByDate(_getYesterdayDate());

    if (yesterdayQuest != null && pool.length > 1) {
      final filteredPool = pool.where((doc) {
        final data = doc.data();
        final sourceQuestID = data['sourceQuestID'] ?? doc.id;

        return sourceQuestID != yesterdayQuest.sourceQuestID;
      }).toList();

      if (filteredPool.isNotEmpty) {
        pool = filteredPool;
      }
    }

    final random = Random();
    final selectedDoc = pool[random.nextInt(pool.length)];
    final selectedData = selectedDoc.data();

    final newDocID = 'daily_$date';

    final newQuestData = {
      'title': selectedData['title'] ?? '',
      'description': selectedData['description'] ?? '',
      'difficulty': selectedData['difficulty'] ?? 'easy',
      'xp': _toInt(selectedData['xp']),
      'date': date,
      'createdAt': FieldValue.serverTimestamp(),
      'sourceQuestID': selectedData['sourceQuestID'] ?? selectedDoc.id,
      'isTemplate': false,
    };

    await _dailySideQuestCollection.doc(newDocID).set(newQuestData);

    final newDoc = await _dailySideQuestCollection.doc(newDocID).get();

    return DailySideQuest.fromFirestore(newDoc);
  }

  String _getYesterdayDate() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    return _formatDate(yesterday);
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  int _toInt(dynamic value) {
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

  String _completedSideQuestID({
    required String userID,
    required String sideQuestID,
    required String date,
  }) {
    return '${userID}_${sideQuestID}_$date';
  }
}