import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

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
    _recorder.dispose();
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
            encoder: AudioEncoder.aacLc,
            sampleRate: 44100,
            numChannels: 1,
            echoCancel: true,
            noiseSuppress: true,
            autoGain: true,
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

    if (!_hasRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.recordSomethingFirst),
        ),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      String? audioUrl;

      if (_recordedPath == null) {
        throw Exception('No audio file found');
      }

      final audioFile = File(_recordedPath!);

      if (!audioFile.existsSync() || audioFile.lengthSync() == 0) {
        throw Exception('Audio file is empty or missing');
      }

      final ref = FirebaseStorage.instance
          .ref()
          .child('audio')
          .child(user.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}.m4a');

      await ref.putFile(
        audioFile,
        SettableMetadata(contentType: 'audio/mp4'),
      );

      audioUrl = await ref.getDownloadURL();

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final username = userDoc.data()?['username'] ?? 'Unknown user';
      final profileImageUrl = userDoc.data()?['profileImageUrl'];

      await _dailySideQuestService.completeDailySideQuestFromUpload(
        userID: user.uid,
        sideQuestID: widget.quest.id,
        date: widget.quest.date,
        xp: 0,
        mediaType: 'audio',
        mediaPath: audioUrl,
        caption: _captionController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'userEmail': user.email,
        'username': username,
        'profileImageUrl': profileImageUrl,
        'caption': _captionController.text.trim(),
        'questTitle': widget.quest.title,
        'questId': widget.quest.id,
        'questDate': widget.quest.date,
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

      if (widget.quest.isGroupQuest) {
        await FirebaseFirestore.instance
            .collection('group_challenge_runs')
            .doc(widget.quest.id)
            .update({
          'status': 'completed',
          'completedBy': user.uid,
          'completedAt': FieldValue.serverTimestamp(),
          'lockedBy': FieldValue.delete(),
          'lockedAt': FieldValue.delete(),
        });
      }

      ProfilePostStorage.posts.insert(
        0,
        ProfilePost(
          userName: user.email ?? 'You',
          timeAgo: 'now',
          location: '',
          caption: _captionController.text.trim(),
          questTitle: widget.quest.title,
          assetPath: audioUrl,
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
          content: Text(l10n.couldNotPostAudioSolution(error.toString())),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final buttonColor =
    _isRecording ? const Color(0xFFEB5D4F) : const Color(0xFF00B2AA);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        title: Text(
          l10n.audioSolution,
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
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.quest.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.quest.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                          ? l10n.recordingTapToStop
                          : _hasRecording
                          ? l10n.recordingReady
                          : l10n.tapToRecord,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
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
                      ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                      : Text(
                    l10n.postAudioSolution,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
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