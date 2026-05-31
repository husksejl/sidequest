import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../data/profile_post_storage.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../screens/own_profile/models/profile_post.dart';
import '../../shared/services/daily_sidequest_service.dart';
import 'models/create_quest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 1080,
      minHeight: 1080,
      quality: 75,
    );

    if (compressedBytes == null) throw Exception('Image compression failed');

    final ref = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(userId)
        .child(fileName);

    await ref.putData(
      compressedBytes,
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
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.youNeedToBeLoggedInToPost),
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
        xp: 0,
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
        'questDate': widget.quest.date,
        'imageUrl': imageUrl,
        'mediaType': 'image',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
        'votingEndsAt': Timestamp.fromDate(
            DateTime.now().add(const Duration(hours: 24))
        ),
        'completedVotes': 0,
        'failedVotes': 0,
        'completedVotedBy': [],
        'failedVotedBy': [],
        'xpAwarded': false,
      });

      ProfilePostStorage.posts.insert(
        0,
        ProfilePost(
          userName: username,
          timeAgo: 'now',
          location: '',
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
          content: Text(l10n.couldNotPostSolution(error.toString())),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        title: Text(
          l10n.create,
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
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _captionController,
                    maxLines: 3,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.addCaption,
                      hintStyle: TextStyle(
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
                          ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                          : Text(
                        l10n.postSolution,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
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