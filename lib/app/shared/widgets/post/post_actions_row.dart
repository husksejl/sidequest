import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../screens/home_screen/widgets/comments_bottom_sheet.dart';

class PostActionsRow extends StatelessWidget {
  final String? firestoreId;
  final int initialLikes;
  final int initialComments;
  final Color statusColor;
  final String statusText;

  const PostActionsRow({
    super.key,
    required this.firestoreId,
    required this.initialLikes,
    required this.initialComments,
    required this.statusColor,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(firestoreId)
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();

            final likedBy =
            List<String>.from(data?['likedBy'] ?? []);

            final currentUserId =
                FirebaseAuth.instance.currentUser?.uid ?? '';

            final isLiked =
            likedBy.contains(currentUserId);

            final likes =
                data?['likes'] ?? initialLikes;

            return GestureDetector(
              onTap: () async {
                if (firestoreId == null ||
                    currentUserId.isEmpty) {
                  return;
                }

                final postRef = FirebaseFirestore.instance
                    .collection('posts')
                    .doc(firestoreId);

                if (isLiked) {
                  await postRef.update({
                    'likedBy':
                    FieldValue.arrayRemove([currentUserId]),
                    'likes': FieldValue.increment(-1),
                  });
                } else {
                  await postRef.update({
                    'likedBy':
                    FieldValue.arrayUnion([currentUserId]),
                    'likes': FieldValue.increment(1),
                  });
                }
              },
              child: _SmallStat(
                icon: isLiked
                    ? Icons.favorite
                    : Icons.favorite_border_rounded,
                value: '$likes',
                color: const Color(0xFFEB5D4F),
              ),
            );
          },
        ),

        const SizedBox(width: 8),

        GestureDetector(
          onTap: () {
            if (firestoreId == null) return;

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => CommentsBottomSheet(
                postId: firestoreId!,
              ),
            );
          },
          child: _SmallStat(
            icon: Icons.chat_bubble_outline_rounded,
            value: '$initialComments',
            color: const Color(0xFF00B2AA),
          ),
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            statusText.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _SmallStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}