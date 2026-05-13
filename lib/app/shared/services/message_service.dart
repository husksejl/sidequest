import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';
import 'chat_service.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();

  CollectionReference<Map<String, dynamic>> _messagesCollection(String chatID) {
    return _firestore.collection('chats').doc(chatID).collection('messages');
  }

  Future<void> sendMessage({
    required String chatID,
    required String senderID,
    required String text,
  }) async {
    final trimmedText = text.trim();

    if (trimmedText.isEmpty) {
      return;
    }

    final now = DateTime.now();

    final message = ChatMessage(
      id: '',
      senderID: senderID,
      sentAt: now,
      text: trimmedText,
    );

    await _messagesCollection(chatID).add(message.toMap());

    await _chatService.updateLastMessage(
      chatID: chatID,
      lastMessage: trimmedText,
    );
  }

  Stream<List<ChatMessage>> watchMessages(String chatID) {
    return _messagesCollection(chatID)
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ChatMessage.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> deleteMessage({
    required String chatID,
    required String messageID,
  }) async {
    await _messagesCollection(chatID).doc(messageID).delete();
  }
}