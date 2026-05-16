import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home_screen/models/sidequest_post.dart';
import '../../home_screen/widgets/sidequest_post_card.dart';

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

        return GestureDetector(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              data['imageUrl'] ?? '',
              fit: BoxFit.cover,
            ),
          ),
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
      timeAgo: 'now',
      location: 'SideQuest',
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
      backgroundColor: const Color(0xFF050608),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050608),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'SideQuest Posts',
          style: TextStyle(
            color: Colors.white,
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