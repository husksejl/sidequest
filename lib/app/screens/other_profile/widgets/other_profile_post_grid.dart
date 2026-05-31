import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home_screen/models/sidequest_post.dart';
import '../../home_screen/widgets/sidequest_post_card.dart';
import '../../own_profile/models/profile_post.dart';
import '../../own_profile/widgets/profile_post_tile.dart';


String getVoteStatus(Map<String, dynamic> data) {
  final votingEndsAt = data['votingEndsAt'];

  if (votingEndsAt == null) return 'open';

  final endTime = votingEndsAt.toDate();

  if (DateTime.now().isBefore(endTime)) {
    return 'open';
  }

  final completedVotes = data['completedVotes'] ?? 0;
  final failedVotes = data['failedVotes'] ?? 0;

  if (completedVotes > failedVotes) return 'completed';
  if (failedVotes > completedVotes) return 'failed';

  return 'undecided';
}


class OtherProfilePostGrid extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  const OtherProfilePostGrid({
    super.key,
    required this.docs,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: docs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final data = docs[index].data();

        return ProfilePostTile(
          post: ProfilePost(
            userName: data['username'] ?? 'Unknown',
            timeAgo: 'now',
            location: '',
            caption: data['caption'] ?? '',
            questTitle: data['questTitle'] ?? '',
            assetPath: data['mediaType'] == 'audio'
                ? (data['audioUrl'] ?? '')
                : (data['imageUrl'] ?? ''),
            completedVotes: data['completedVotes'] ?? 0,
            notCompletedVotes: data['failedVotes'] ?? 0,
            type: data['mediaType'] == 'audio'
                ? ProfilePostType.audio
                : ProfilePostType.image,
            voteStatus: switch (getVoteStatus(data)) {
              'completed' => VoteStatus.completed,
              'failed' => VoteStatus.failed,
              'undecided' => VoteStatus.undecided,
              _ => VoteStatus.open,
            },

            votingOpen: getVoteStatus(data) == 'open',
            likes: data['likes'] ?? 0,
            comments: data['comments'] ?? 0,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FirestorePostDetailPage(
                  docs: docs,
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

class FirestorePostDetailPage extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final int initialIndex;

  const FirestorePostDetailPage({
    super.key,
    required this.docs,
    required this.initialIndex,
  });

  @override
  State<FirestorePostDetailPage> createState() =>
      _FirestorePostDetailPageState();
}

class _FirestorePostDetailPageState extends State<FirestorePostDetailPage> {
  final ScrollController _scrollController = ScrollController();

  static const double estimatedPostHeight = 720;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        widget.initialIndex * estimatedPostHeight,
      );
    });
  }

  String _formatPostTime(dynamic timestamp) {
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  SideQuestPost _toPost(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return SideQuestPost(
      userId: data['userId'],
      userName: data['username'] ?? 'Unknown',
      audioUrl: data['audioUrl'],
      mediaType: data['mediaType'] ?? 'image',
      voteStatus: _getVoteStatus(data),
      votingOpen: _getVoteStatus(data) == 'open',
      timeAgo: _formatPostTime(data['createdAt']),
      location: '',
      title: data['questTitle'] ?? '',
      imageEmoji: '',
      imageLabelTop: '',
      imageLabelBottom: '',
      caption: data['caption'] ?? '',
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      completedVotes: data['completedVotes'] ?? 0,
      notCompletedVotes: data['failedVotes'] ?? 0,
      imageUrl: data['imageUrl'],
      profileImageUrl: data['profileImageUrl'],
      firestoreId: doc.id,
      isOwnPost: data['userId'] == FirebaseAuth.instance.currentUser?.uid,
      isFirestorePost: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        title: Text(
          'SideQuest Posts',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        itemCount: widget.docs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SideQuestPostCard(
              post: _toPost(widget.docs[index]),
            ),
          );
        },
      ),
    );
  }
}