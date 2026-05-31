import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

class MessageInputBar extends StatefulWidget {
  final bool isSending;
  final Future<void> Function(String text) onSend;

  const MessageInputBar({
    super.key,
    required this.isSending,
    required this.onSend,
  });

  @override
  State<MessageInputBar> createState() {
    return _MessageInputBarState();
  }
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _messageController = TextEditingController();

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();

    if (text.isEmpty || widget.isSending) {
      return;
    }

    await widget.onSend(text);

    if (mounted) {
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
      color: isLight
          ? theme.scaffoldBackgroundColor
          : theme.colorScheme.surface,
      child: Row(
        children: [
          Icon(
            Icons.add,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isLight
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(
                    alpha: isLight ? 0.30 : 0.16,
                  ),
                ),
              ),
              child: TextField(
                controller: _messageController,
                enabled: !widget.isSending,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: l10n.typeMessage,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) {
                  _handleSend();
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.isSending ? null : _handleSend,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.isSending
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.20)
                    : const Color(0xFFFF7A66),
                shape: BoxShape.circle,
              ),
              child: widget.isSending
                  ? const Padding(
                padding: EdgeInsets.all(14),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
                  : Icon(
                Icons.send_rounded,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}