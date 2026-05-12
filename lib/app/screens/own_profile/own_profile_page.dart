import 'package:flutter/material.dart';

import '../../shared/widgets/custom_bottom_nav.dart';
import 'models/profile_post.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_action_buttons.dart';
import 'widgets/profile_post_grid.dart';
import 'widgets/profile_level_bar.dart';
import '../../shared/widgets/top_bar.dart';

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
                  Icon(
                    Icons.grid_on_rounded,
                    color: Color(0xFF00B2AA),
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 14),
              ProfilePostGrid(posts: posts),
            ],
          ),
        ),
      ),
    );
  }
}
