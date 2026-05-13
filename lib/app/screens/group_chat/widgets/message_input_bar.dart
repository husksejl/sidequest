import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
      color: const Color(0xFF050608),
      child: Row(
        children: [
          const Icon(
            Icons.add,
            color: Colors.grey,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextField(
                controller: _messageController,
                enabled: !widget.isSending,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
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
                    ? const Color(0xFF4A4A4A)
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
                  : const Icon(
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