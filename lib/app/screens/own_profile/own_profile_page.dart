import 'package:flutter/material.dart';

import '../../shared/widgets/custom_bottom_nav.dart';
import 'models/profile_post.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_action_buttons.dart';
import 'widgets/profile_post_grid.dart';
import 'widgets/profile_level_bar.dart';
import '../../shared/widgets/top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnProfilePage extends StatelessWidget {
  const OwnProfilePage({super.key});

  static const List<ProfilePost> posts = [
    ProfilePost(
      userName: 'Franz Hermann',
      timeAgo: '3h ago',
      location: 'Vienna',
      questTitle: 'Take a photo of something that made you smile today',
      caption: 'I put on a wig and suddenly have opinions #quirky',
      assetPath: 'assets/images/Max.jpg',
      type: ProfilePostType.image,
      voteStatus: VoteStatus.open,
      votingOpen: true,
      likes: 124,
      comments: 18,
    ),
    ProfilePost(
      userName: 'Franz Hermann',
      timeAgo: '1d ago',
      location: 'Campus',
      questTitle: 'Make someone smile',
      caption: 'Text proof counts too. I wrote my sidequest answer before coffee.',
      assetPath: 'assets/images/Max.jpg',
      type: ProfilePostType.text,
      voteStatus: VoteStatus.failed,
      votingOpen: false,
      likes: 89,
      comments: 11,
    ),
    ProfilePost(
      userName: 'Franz Hermann',
      timeAgo: '2d ago',
      location: 'Home',
      questTitle: 'Record a voice message while outside',
      caption: 'Voice note challenge completed. Honestly iconic.',
      assetPath: 'assets/images/Max.jpg',
      type: ProfilePostType.audio,
      voteStatus: VoteStatus.completed,
      votingOpen: false,
      likes: 66,
      comments: 7,
    ),
    ProfilePost(
      userName: 'Franz Hermann',
      timeAgo: '3d ago',
      location: 'Vienna',
      questTitle: 'Post a moment that felt unreal',
      caption: 'Tiny moment, big proof.',
      assetPath: 'assets/images/Max.jpg',
      type: ProfilePostType.video,
      voteStatus: VoteStatus.completed,
      votingOpen: false,
      likes: 142,
      comments: 22,
    ),
    ProfilePost(
      userName: 'Franz Hermann',
      timeAgo: '4d ago',
      location: 'Train',
      questTitle: 'Take a selfie with something yellow',
      caption: 'Sidequest done while commuting.',
      assetPath: 'assets/images/Max.jpg',
      type: ProfilePostType.image,
      voteStatus: VoteStatus.failed,
      votingOpen: false,
      likes: 54,
      comments: 5,
    ),
    ProfilePost(
      userName: 'Franz Hermann',
      timeAgo: '5d ago',
      location: 'City',
      questTitle: 'Go outside',
      caption: 'Proof that I actually went outside.',
      assetPath: 'assets/images/Max.jpg',
      type: ProfilePostType.image,
      voteStatus: VoteStatus.undecided,
      votingOpen: false,
      likes: 101,
      comments: 14,
    ),
  ];

  static String _formatPostTime(dynamic timestamp) {
    if (timestamp == null) return 'now';

    final DateTime createdAt = timestamp.toDate();
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) return 'now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'yesterday';

    return '${difference.inDays}d ago';
  }

  String _getVoteStatus(Map<String, dynamic> data) {
    final votingEndsAt = data['votingEndsAt'];

    if (votingEndsAt == null) return 'open';

    final endTime = votingEndsAt.toDate();

    if (DateTime.now().isBefore(endTime)) {
      return 'open';
    }

    final completedVotes = data['completedVotes'] ?? 0;
    final failedVotes = data['failedVotes'] ?? 0;

    if (completedVotes > failedVotes) {
      return 'completed';
    }

    if (failedVotes > completedVotes) {
      return 'failed';
    }

    return 'undecided';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(),

              const ProfileHeader(),
              const SizedBox(height: 18),

              const ProfileActionButtons(),
              const SizedBox(height: 16),

              const ProfileLevelBar(),
              const SizedBox(height: 28),

              Row(
                children: const [
                  Text(
                    'POSTED SIDEQUESTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  Spacer(),
                ],
              ),

              const SizedBox(height: 14),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEB5D4F),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  docs.sort((a, b) {
                    final aTime = a.data()['createdAt'] as Timestamp?;
                    final bTime = b.data()['createdAt'] as Timestamp?;

                    if (aTime == null || bTime == null) return 0;

                    return bTime.compareTo(aTime);
                  });

                  final firebasePosts = docs.map((doc) {
                    final data = doc.data();

                    return ProfilePost(
                      firestoreId: doc.id,
                      userName: data['username'] ?? 'Unknown',
                      timeAgo: _formatPostTime(data['createdAt']),
                      location: '',
                      questTitle: data['questTitle'] ?? '',
                      caption: data['caption'] ?? '',
                      assetPath: data['mediaType'] == 'audio'
                          ? (data['audioUrl'] ?? '')
                          : (data['imageUrl'] ?? ''),
                      type: data['mediaType'] == 'audio'
                          ? ProfilePostType.audio
                          : ProfilePostType.image,
                      voteStatus: switch (_getVoteStatus(data)) {
                        'completed' => VoteStatus.completed,
                        'failed' => VoteStatus.failed,
                        'undecided' => VoteStatus.undecided,
                        _ => VoteStatus.open,
                      },

                      votingOpen: _getVoteStatus(data) == 'open',
                      likes: data['likes'] ?? 0,
                      comments: data['comments'] ?? 0,
                      completedVotes: data['completedVotes'] ?? 0,
                      notCompletedVotes: data['failedVotes'] ?? 0,
                      profileImageUrl: data['profileImageUrl'],
                    );
                  }).toList();

                  return ProfilePostGrid(posts: firebasePosts);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
