class ChatMessage {
  final String senderName;
  final String text;
  final bool isOwnMessage;

  const ChatMessage({
    required this.senderName,
    required this.text,
    required this.isOwnMessage,
  });
}