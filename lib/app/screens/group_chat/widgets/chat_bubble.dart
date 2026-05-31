import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isOwnMessage) {
      return buildOwnMessage(context);
    } else {
      return buildOtherMessage(context);
    }
  }

  Widget buildOwnMessage(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.senderName,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isLight
                  ? const Color(0xFFFF7A66).withValues(alpha: 0.14)
                  : const Color(0xFF4A2421),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF7A66).withValues(
                  alpha: isLight ? 0.35 : 0.25,
                ),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOtherMessage(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAvatar(context),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.senderName,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isLight
                      ? const Color(0xFF00E5FF).withValues(alpha: 0.10)
                      : const Color(0xFF102326),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00E5FF).withValues(
                      alpha: isLight ? 0.28 : 0.2,
                    ),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isLight
            ? const Color(0xFF00E5FF).withValues(alpha: 0.10)
            : const Color(0xFF102326),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF00E5FF),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.person,
        color: theme.colorScheme.onSurface,
        size: 18,
      ),
    );
  }
}