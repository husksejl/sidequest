import 'package:flutter/material.dart';

import '../models/message_thread.dart';
import '../../group_chat/group_chat_page.dart';
import '../widgets/messages_thread_card.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MessageThread> threads = [
      const MessageThread(
        name: 'Elena Juni',
        preview: 'That quest at the neon district was amazing...',
        time: '2m ago',
      ),
      const MessageThread(
        name: 'Weekend Warriors',
        preview: 'Let’s meet at the harbor quest.',
        time: '1h ago',
        isGroup: true,
      ),
      const MessageThread(
        name: 'Jax Void',
        preview: 'Sent a file: quest_map_v2.png',
        time: '4h ago',
      ),
      const MessageThread(
        name: 'Sarah The Glitch',
        preview: 'Don’t forget to upgrade your rig before the next quest.',
        time: 'Yesterday',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        buildSearchBar(),
        const SizedBox(height: 20),

        for (int i = 0; i < threads.length; i++)
          MessageThreadCard(
            thread: threads[i],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupChatPage(),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 22,
          ),
          SizedBox(width: 10),
          Text(
            'Search conversations...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}