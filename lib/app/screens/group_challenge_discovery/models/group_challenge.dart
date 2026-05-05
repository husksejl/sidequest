class GroupChallenge {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final int members;
  final int quests;
  final String category;
  final String level;
  final String reward;
  final String time;
  final List<String> questIdeas;

  const GroupChallenge({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.members,
    required this.quests,
    required this.category,
    required this.level,
    required this.reward,
    required this.time,
    required this.questIdeas,
  });
}