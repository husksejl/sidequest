import 'package:flutter/material.dart';

import '../models/message_thread.dart';

class MessageThreadCard extends StatelessWidget {
  final MessageThread thread;

  const MessageThreadCard({
    super.key,
    required this.thread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          buildAvatar(),
          const SizedBox(width: 14),
          Expanded(
            child: buildTextContent(),
          ),
          const SizedBox(width: 8),
          Text(
            thread.time.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF102326),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00E5FF),
              width: 1.5,
            ),
          ),
          child: Icon(
            thread.isGroup ? Icons.groups_rounded : Icons.person,
            color: Colors.white,
            size: 26,
          ),
        ),
        if (!thread.isGroup)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF151515),
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          thread.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          thread.preview,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}