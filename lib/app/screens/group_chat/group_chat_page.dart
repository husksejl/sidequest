import 'package:flutter/material.dart';

import 'models/chat_message.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/message_input_bar.dart';
import 'widgets/quest_header_card.dart';
import '../../shared/top_bar.dart';

class GroupChatPage extends StatelessWidget {
  const GroupChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> messages = [
      const ChatMessage(
        senderName: 'Jax',
        text:
        'Yo! Who’s hitting the downtown sector tonight? I heard there’s a new cyberpunk cafe with crazy lights.',
        isOwnMessage: false,
      ),
      const ChatMessage(
        senderName: 'Elena',
        text:
        'Just found this gem near the old harbor. Quest complete?',
        isOwnMessage: false,
      ),
      const ChatMessage(
        senderName: 'Sarah',
        text:
        'That’s insane, Elena! The reflections on the glass are perfect. Uploading mine in a sec.',
        isOwnMessage: true,
      ),
      const ChatMessage(
        senderName: 'Jax',
        text: 'Definite quest points for that one.',
        isOwnMessage: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            const QuestHeaderCard(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                children: [
                  for (int i = 0; i < messages.length; i++)
                    ChatBubble(message: messages[i]),
                ],
              ),
            ),
            const MessageInputBar(),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Neon Night Crawlers',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '12 ACTIVE MEMBERS',
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
              Icons.group,
              color: Color(0xFF00E5FF),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}