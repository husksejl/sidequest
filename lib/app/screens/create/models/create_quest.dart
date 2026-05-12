class CreateQuest {
  final String title;
  final String expiresIn;
  final bool isGroupQuest;

  const CreateQuest({
    required this.title,
    required this.expiresIn,
    required this.isGroupQuest,
  });
}