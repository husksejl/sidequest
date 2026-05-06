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
}

class ProfilePost {
  final String userName;
  final String timeAgo;
  final String location;
  final String caption;
  final String assetPath;
  final ProfilePostType type;
  final VoteStatus voteStatus;
  final bool votingOpen;
  final int likes;
  final int comments;

  const ProfilePost({
    required this.userName,
    required this.timeAgo,
    required this.location,
    required this.caption,
    required this.assetPath,
    required this.type,
    required this.voteStatus,
    required this.votingOpen,
    required this.likes,
    required this.comments,
  });
}