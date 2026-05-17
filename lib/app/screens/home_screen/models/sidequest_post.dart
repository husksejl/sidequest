class SideQuestPost {
  final String userName;
  final String timeAgo;
  final String location;
  final String title;
  final String imageEmoji;
  final String imageLabelTop;
  final String imageLabelBottom;
  final String caption;
  final int likes;
  final int comments;
  final int completedVotes;
  final int notCompletedVotes;

  final String? imageUrl;
  final String? profileImageUrl;
  final String? firestoreId;
  final bool isOwnPost;
  final bool isFirestorePost;
  final String? userId;
  final String voteStatus;
  final bool votingOpen;
  final String mediaType;
  final String? audioUrl;

  const SideQuestPost({
    required this.userName,
    required this.timeAgo,
    required this.location,
    required this.title,
    required this.imageEmoji,
    required this.imageLabelTop,
    required this.imageLabelBottom,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.completedVotes,
    required this.notCompletedVotes,
    this.userId,


    this.imageUrl,
    this.profileImageUrl,
    this.firestoreId,
    this.isOwnPost = false,
    this.isFirestorePost = false,
    this.voteStatus = 'open',
    this.votingOpen = true,
    this.mediaType = 'image',
    this.audioUrl,
  });
}
