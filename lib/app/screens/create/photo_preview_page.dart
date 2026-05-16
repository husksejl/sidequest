import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/profile_post_storage.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../screens/own_profile/models/profile_post.dart';
import '../../shared/services/daily_sidequest_service.dart';
import 'models/create_quest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoPreviewPage extends StatefulWidget {
  final String imagePath;
  final CreateQuest quest;

  const PhotoPreviewPage({
    super.key,
    required this.imagePath,
    required this.quest,
  });

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  final TextEditingController _captionController = TextEditingController();
  final DailySideQuestService _dailySideQuestService = DailySideQuestService();

  bool _isPosting = false;

  Future<String> _uploadImageToStorage({
    required String userId,
    required String imagePath,
  }) async {
    final file = File(imagePath);

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final ref = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(userId)
        .child(fileName);

    await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return ref.getDownloadURL();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _postSolution() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to post.'),
        ),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      final imageUrl = await _uploadImageToStorage(
        userId: user.uid,
        imagePath: widget.imagePath,
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final username = userDoc.data()?['username'] ?? 'Unknown user';

      await _dailySideQuestService.completeDailySideQuestFromUpload(
        userID: user.uid,
        sideQuestID: widget.quest.id,
        date: widget.quest.date,
        xp: widget.quest.xp,
        mediaType: 'image',
        mediaPath: widget.imagePath,
        caption: _captionController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'username': username,
        'profileImageUrl': userDoc.data()?['profileImageUrl'],
        'caption': _captionController.text.trim(),
        'questTitle': widget.quest.title,
        'questId': widget.quest.id,
        'imageUrl': imageUrl,
        'mediaType': 'image',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
      });

      ProfilePostStorage.posts.insert(
        0,
        ProfilePost(
          userName: username,
          timeAgo: 'now',
          location: 'SideQuest',
          caption: _captionController.text.trim(),
          questTitle: widget.quest.title,
          assetPath: widget.imagePath,
          type: ProfilePostType.image,
          voteStatus: VoteStatus.open,
          votingOpen: true,
          likes: 0,
          comments: 0,
        ),
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
            (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isPosting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not post solution: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050608),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Preview',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
              decoration: const BoxDecoration(
                color: Color(0xFF0E1014),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(34),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.quest.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.quest.difficulty.toUpperCase()}  •  ${widget.quest.xp} XP',
                    style: const TextStyle(
                      color: Color(0xFFEB5D4F),
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _captionController,
                    maxLines: 3,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a caption...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF777982),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF171A20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isPosting ? null : _postSolution,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB5D4F),
                        disabledBackgroundColor: const Color(0xFF5A2B27),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: _isPosting
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'POST SOLUTION',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}