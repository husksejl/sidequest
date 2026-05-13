import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/models/chat_message.dart' as firestore_message;
import '../../shared/services/message_service.dart';
import 'models/chat_message.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/message_input_bar.dart';
import 'widgets/quest_header_card.dart';

class GroupChatPage extends StatefulWidget {
  final String chatID;
  final String chatName;

  const GroupChatPage({
    super.key,
    required this.chatID,
    required this.chatName,
  });

  @override
  State<GroupChatPage> createState() {
    return _GroupChatPageState();
  }
}

class _GroupChatPageState extends State<GroupChatPage> {
  final MessageService _messageService = MessageService();

  bool _isSending = false;

  Future<void> _sendMessage(String text) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to send messages.'),
          backgroundColor: Color(0xFF8B1E2D),
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      await _messageService.sendMessage(
        chatID: widget.chatID,
        senderID: currentUser.uid,
        text: text,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message could not be sent: $error'),
          backgroundColor: const Color(0xFF8B1E2D),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isSending = false;
      });
    }
  }

  ChatMessage _toBubbleMessage(
      firestore_message.ChatMessage message,
      String currentUserID,
      ) {
    final bool isOwnMessage = message.senderID == currentUserID;

    return ChatMessage(
      senderName: isOwnMessage ? 'You' : widget.chatName,
      text: message.text,
      isOwnMessage: isOwnMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF050608),
        body: SafeArea(
          child: Center(
            child: Text(
              'You need to be logged in to view this chat.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(context),
            const QuestHeaderCard(),
            Expanded(
              child: StreamBuilder<List<firestore_message.ChatMessage>>(
                stream: _messageService.watchMessages(widget.chatID),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Messages could not be loaded.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00E5FF),
                      ),
                    );
                  }

                  final messages = snapshot.data!;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet.\nSend the first message.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                    children: [
                      for (int i = 0; i < messages.length; i++)
                        ChatBubble(
                          message: _toBubbleMessage(
                            messages[i],
                            currentUser.uid,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            MessageInputBar(
              isSending: _isSending,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E5FF),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatName,
                  style: const TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'DIRECT MESSAGE',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF102326),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00E5FF).withOpacity(0.6),
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF00E5FF),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}