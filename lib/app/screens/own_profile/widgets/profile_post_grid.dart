import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../models/profile_post.dart';
import 'profile_post_tile.dart';
import '../../home_screen/widgets/sidequest_post_card.dart';
import '../../home_screen/models/sidequest_post.dart';

class ProfilePostGrid extends StatelessWidget {
  final List<ProfilePost> posts;

  const ProfilePostGrid({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: posts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];

        return ProfilePostTile(
          post: post,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePostDetailPage(
                  posts: posts,
                  initialIndex: index,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProfilePostDetailPage extends StatefulWidget {
  final List<ProfilePost> posts;
  final int initialIndex;

  const ProfilePostDetailPage({
    super.key,
    required this.posts,
    required this.initialIndex,
  });

  @override
  State<ProfilePostDetailPage> createState() => _ProfilePostDetailPageState();
}

class _ProfilePostDetailPageState extends State<ProfilePostDetailPage> {
  final ScrollController _scrollController = ScrollController();

  static const double estimatedPostHeight = 560;

  SideQuestPost _toSideQuestPost(ProfilePost post) {
    return SideQuestPost(
      userName: post.userName,
      timeAgo: post.timeAgo,
      location: post.location,
      title: post.questTitle,
      imageEmoji: '',
      imageLabelTop: '',
      imageLabelBottom: '',
      caption: post.caption,
      likes: post.likes,
      comments: post.comments,
      completedVotes: post.completedVotes,
      notCompletedVotes: post.notCompletedVotes,
      imageUrl: post.type == ProfilePostType.audio ? null : post.assetPath,
      audioUrl: post.type == ProfilePostType.audio ? post.assetPath : null,
      profileImageUrl: post.profileImageUrl,
      firestoreId: post.firestoreId,
      isOwnPost: true,
      isFirestorePost: true,
      voteStatus: post.voteStatus.name,
      votingOpen: post.votingOpen,
      mediaType: post.type == ProfilePostType.audio ? 'audio' : 'image',
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.jumpTo(
        widget.initialIndex * estimatedPostHeight,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          l10n.sideQuestPosts,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SideQuestPostCard(
              post: _toSideQuestPost(widget.posts[index]),
            ),
          );
        },
      ),
    );
  }
}