class CreateQuest {
  final String id;
  final String title;
  final String description;
  final String expiresIn;
  final String difficulty;
  final int xp;
  final bool isGroupQuest;
  final String date;

  const CreateQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.expiresIn,
    required this.difficulty,
    required this.xp,
    required this.isGroupQuest,
    required this.date,
  });
}