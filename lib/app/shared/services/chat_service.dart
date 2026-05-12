import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_chat.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _chatsCollection {
    return _firestore.collection('chats');
  }

  Future<String> createDirectChat({
    required String currentUserID,
    required String otherUserID,
  }) async {
    final existingChat = await _findExistingDirectChat(
      currentUserID: currentUserID,
      otherUserID: otherUserID,
    );

    if (existingChat != null) {
      return existingChat.id;
    }

    final chat = AppChat(
      id: '',
      lastMessage: '',
      memberIDs: [
        currentUserID,
        otherUserID,
      ],
      type: 'dm',
      updatedAt: DateTime.now(),
    );

    final docRef = await _chatsCollection.add(chat.toMap());

    return docRef.id;
  }

  Future<AppChat?> _findExistingDirectChat({
    required String currentUserID,
    required String otherUserID,
  }) async {
    final querySnapshot = await _chatsCollection
        .where('type', isEqualTo: 'dm')
        .where('memberIDs', arrayContains: currentUserID)
        .get();

    for (final doc in querySnapshot.docs) {
      final chat = AppChat.fromFirestore(doc);

      if (chat.memberIDs.contains(otherUserID)) {
        return chat;
      }
    }

    return null;
  }

  Stream<List<AppChat>> watchChatsForUser(String userID) {
    return _chatsCollection
        .where('memberIDs', arrayContains: userID)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return AppChat.fromFirestore(doc);
      }).toList();
    });
  }

  Future<AppChat?> getChatByID(String chatID) async {
    final doc = await _chatsCollection.doc(chatID).get();

    if (!doc.exists) {
      return null;
    }

    return AppChat.fromFirestore(doc);
  }

  Future<void> updateLastMessage({
    required String chatID,
    required String lastMessage,
  }) async {
    await _chatsCollection.doc(chatID).update({
      'lastMessage': lastMessage,
      'updatedAt': Timestamp.now(),
    });
  }
}