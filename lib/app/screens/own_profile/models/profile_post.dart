enum ProfilePostType {
  image,
  video,
  audio,
  text,
}

enum VoteStatus {
  completed,
  failed,
  undecided,
  open,
}

class ProfilePost {
  final String userName;
  final String timeAgo;
  final String location;
  final String caption;
  final String questTitle;
  final String assetPath;
  final ProfilePostType type;
  final VoteStatus voteStatus;
  final bool votingOpen;
  final int likes;
  final int comments;
  final String? profileImageUrl;
  final String? firestoreId;
  final int completedVotes;
  final int notCompletedVotes;
  final bool isGroupQuest;
  final List<String> participantIds;

  const ProfilePost({
    required this.userName,
    required this.timeAgo,
    required this.location,
    required this.caption,
    required this.questTitle,
    required this.assetPath,
    required this.type,
    required this.voteStatus,
    required this.votingOpen,
    required this.likes,
    required this.comments,
    this.profileImageUrl,
    this.firestoreId,
    this.completedVotes = 0,
    this.notCompletedVotes = 0,
    this.isGroupQuest = false,
    this.participantIds = const [],
  });
}