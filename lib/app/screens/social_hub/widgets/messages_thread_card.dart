import 'package:flutter/material.dart';

import '../models/message_thread.dart';

class MessageThreadCard extends StatelessWidget {
  final MessageThread thread;
  final VoidCallback onTap;

  const MessageThreadCard({
    super.key,
    required this.thread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            buildAvatar(context),
            const SizedBox(width: 14),
            Expanded(
              child: buildTextContent(context),
            ),
            const SizedBox(width: 8),
            Text(
              thread.time.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.56),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAvatar(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          child: Icon(
            thread.isGroup ? Icons.groups_rounded : Icons.person,
            color: Theme.of(context).colorScheme.onSurface,
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
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          thread.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          thread.preview,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.64),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}