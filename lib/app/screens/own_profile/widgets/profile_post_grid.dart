import 'package:flutter/material.dart';
import '../models/profile_post.dart';
import 'profile_post_tile.dart';
import 'profile_post_detail_card.dart';

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
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProfilePostDetailCard(post: widget.posts[index]),
          );
        },
      ),
    );
  }
}