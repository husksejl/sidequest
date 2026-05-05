class MessageThread {
  final String name;
  final String preview;
  final String time;
  final bool isGroup;

  const MessageThread({
    required this.name,
    required this.preview,
    required this.time,
    this.isGroup = false,
  });
}