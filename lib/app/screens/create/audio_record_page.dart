import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/profile_post_storage.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../screens/own_profile/models/profile_post.dart';
import '../../shared/services/daily_sidequest_service.dart';
import 'models/create_quest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class AudioRecordPage extends StatefulWidget {
  final CreateQuest quest;

  const AudioRecordPage({
    super.key,
    required this.quest,
  });

  @override
  State<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
  final TextEditingController _captionController = TextEditingController();
  final DailySideQuestService _dailySideQuestService = DailySideQuestService();

  bool _isRecording = false;
  bool _hasRecording = false;
  bool _isPosting = false;

  final AudioRecorder _recorder = AudioRecorder();

  String? _recordedPath;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();

      print('RECORDED PATH: $path');

      if (path != null) {
        final file = File(path);
        print('AUDIO EXISTS: ${file.existsSync()}');
        print('AUDIO SIZE: ${file.existsSync() ? file.lengthSync() : 0}');
      }

      setState(() {
        _isRecording = false;
        _hasRecording = true;
        _recordedPath = path;
      });
    } else {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();

        final path =
            '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 44100,
            bitRate: 128000,
          ),
          path: path,
        );

        setState(() {
          _isRecording = true;
        });
      }
    }
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

    if (!_hasRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record something first.'),
        ),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      await _dailySideQuestService.completeDailySideQuestFromUpload(
        userID: user.uid,
        sideQuestID: widget.quest.id,
        date: widget.quest.date,
        xp: 0,
        mediaType: 'audio',
        mediaPath: 'local_audio_placeholder',
        caption: _captionController.text.trim(),
      );

      String? audioUrl;

      if (_recordedPath != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('audio')
            .child('${DateTime.now().millisecondsSinceEpoch}.m4a');

        await ref.putFile(
          File(_recordedPath!),
          SettableMetadata(contentType: 'audio/mp4'),
        );

        audioUrl = await ref.getDownloadURL();

        print('AUDIO DOWNLOAD URL: $audioUrl');
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'userEmail': user.email,
        'username': user.displayName ?? user.email ?? 'Unknown',
        'caption': _captionController.text.trim(),
        'questTitle': widget.quest.title,
        'questId': widget.quest.id,
        'mediaType': 'audio',
        'imageUrl': null,
        'audioUrl': audioUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
        'completedVotes': 0,
        'failedVotes': 0,
        'completedVotedBy': [],
        'failedVotedBy': [],
        'votingEndsAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(hours: 24)),
        ),
        'xpAwarded': false,
      });

      ProfilePostStorage.posts.insert(
        0,
        ProfilePost(
          userName: user.email ?? 'You',
          timeAgo: 'now',
          location: '',
          caption: _captionController.text.trim(),
          questTitle: widget.quest.title,
          assetPath: '',
          type: ProfilePostType.audio,
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
          content: Text('Could not post audio solution: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
    _isRecording ? const Color(0xFFEB5D4F) : const Color(0xFF00B2AA);

    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050608),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Audio Solution',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF24100F),
                      Color(0xFF050608),
                      Color(0xFF102322),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.quest.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.quest.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF9DA3AD),
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: _toggleRecording,
                      child: Container(
                        width: 118,
                        height: 118,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: buttonColor.withOpacity(0.16),
                          border: Border.all(
                            color: buttonColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: buttonColor.withOpacity(0.25),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isRecording
                              ? Icons.stop_rounded
                              : Icons.mic_rounded,
                          color: buttonColor,
                          size: 58,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _isRecording
                          ? 'Recording... tap to stop'
                          : _hasRecording
                          ? 'Recording ready'
                          : 'Tap to record',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _captionController,
                maxLines: 3,
                style: const TextStyle(
                  color: Colors.white,
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
              const Spacer(),
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
                    'POST AUDIO SOLUTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}