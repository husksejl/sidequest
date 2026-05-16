import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../other_profile/other_profile_page.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController commentController = TextEditingController();

  Future<void> addComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final userData = userDoc.data();

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'userId': user.uid,
      'username': userData?['username'] ?? 'Unknown',
      'profileImageUrl': userData?['profileImageUrl'],
      'text': text,
      'likes': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({
      'comments': FieldValue.increment(1),
    });

    commentController.clear();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
          decoration: const BoxDecoration(
            color: Color(0xFF101216),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'COMMENTS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .orderBy('createdAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00B2AA),
                        ),
                      );
                    }

                    final comments = snapshot.data!.docs;

                    if (comments.isEmpty) {
                      return const Center(
                        child: Text(
                          'No comments yet.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final doc = comments[index];
                        final data = doc.data();

                        final profileImageUrl =
                        data['profileImageUrl']?.toString();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (data['userId'] == null) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OtherProfilePage(
                                        userId: data['userId'],
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF1B2026),
                                  backgroundImage: profileImageUrl != null &&
                                      profileImageUrl.isNotEmpty
                                      ? NetworkImage(profileImageUrl)
                                      : null,
                                  child: profileImageUrl == null ||
                                      profileImageUrl.isEmpty
                                      ? const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white54,
                                    size: 20,
                                  )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['username'] ?? 'Unknown',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      data['text'] ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFFC8CDD5),
                                        fontSize: 13,
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(widget.postId)
                                                .collection('comments')
                                                .doc(doc.id)
                                                .update({
                                              'likes':
                                              FieldValue.increment(1),
                                            });
                                          },
                                          child: Text(
                                            'Like · ${data['likes'] ?? 0}',
                                            style: const TextStyle(
                                              color: Color(0xFF8A8F98),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        const Text(
                                          'Reply',
                                          style: TextStyle(
                                            color: Color(0xFF8A8F98),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(widget.postId)
                                        .collection('comments')
                                        .doc(doc.id)
                                        .snapshots(),
                                    builder: (context, likeSnapshot) {
                                      final liveData = likeSnapshot.data?.data();

                                      final likedBy = List<String>.from(liveData?['likedBy'] ?? []);
                                      final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
                                      final isLiked = likedBy.contains(currentUserId);

                                      return GestureDetector(
                                        onTap: () async {
                                          final commentRef = FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(widget.postId)
                                              .collection('comments')
                                              .doc(doc.id);

                                          if (isLiked) {
                                            await commentRef.update({
                                              'likedBy': FieldValue.arrayRemove([currentUserId]),
                                              'likes': FieldValue.increment(-1),
                                            });
                                          } else {
                                            await commentRef.update({
                                              'likedBy': FieldValue.arrayUnion([currentUserId]),
                                              'likes': FieldValue.increment(1),
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              isLiked
                                                  ? Icons.favorite_rounded
                                                  : Icons.favorite_border_rounded,
                                              color: const Color(0xFFEB5D4F),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${liveData?['likes'] ?? 0}',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),

                                  PopupMenuButton<String>(
                                    color: const Color(0xFF15181D),
                                    icon: const Icon(
                                      Icons.more_horiz_rounded,
                                      color: Colors.white54,
                                    ),
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'report',
                                        child: Text('Report comment'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF171A20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: addComment,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFF00B2AA),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}