import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart' as record;
import 'package:path_provider/path_provider.dart';

import 'models/create_quest.dart';
import '../../data/profile_post_storage.dart';
import '../own_profile/models/profile_post.dart';
import '../own_profile/own_profile_page.dart';

class AudioRecordPage extends StatefulWidget {
  const AudioRecordPage({
    super.key,
    required this.quest,
  });

  final CreateQuest quest;

  @override
  State<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
  final recorder = record.AudioRecorder();
  final TextEditingController captionController = TextEditingController();

  bool isRecording = false;
  String? audioPath;

  Future<void> startRecording() async {
    final hasPermission = await recorder.hasPermission();

    if (!hasPermission) return;

    final Directory dir = await getApplicationDocumentsDirectory();

    final String path =
        '${dir.path}/sidequest_audio_${DateTime.now().millisecondsSinceEpoch}.wav';

    await recorder.start(
      const record.RecordConfig(
        encoder: record.AudioEncoder.wav,
      ),
      path: path,
    );

    setState(() {
      isRecording = true;
      audioPath = null;
    });
  }

  Future<void> stopRecording() async {
    final path = await recorder.stop();

    if (path != null) {
      final file = File(path);
      print('AUDIO PATH: $path');
      print('AUDIO EXISTS: ${file.existsSync()}');
      print('AUDIO SIZE: ${file.lengthSync()} bytes');
    }

    setState(() {
      isRecording = false;
      audioPath = path;
    });
  }

  Future<void> postAudio() async {
    if (audioPath == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF7668),
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 1));

    ProfilePostStorage.posts.insert(
      0,
      ProfilePost(
        userName: 'Franz Hermann',
        timeAgo: 'now',
        location: 'Vienna',
        questTitle: widget.quest.title.replaceAll('\n', ' '),
        caption: captionController.text.isEmpty
            ? 'Voice note challenge completed.'
            : captionController.text,
        assetPath: audioPath!,
        type: ProfilePostType.audio,
        voteStatus: VoteStatus.open,
        votingOpen: true,
        likes: 0,
        comments: 0,
      ),
    );

    Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const OwnProfilePage(),
      ),
          (route) => false,
    );
  }

  @override
  void dispose() {
    recorder.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasRecording = audioPath != null;

    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Audio Preview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFFF6B5E),
                    width: 7,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B5E).withOpacity(0.28),
                      blurRadius: 26,
                      spreadRadius: 2,
                    ),
                  ],
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2A0F0D),
                      Color(0xFF0A0B0D),
                      Color(0xFF3A1511),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.quest.title.replaceAll('\n', ' '),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF101216),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.quest.isGroupQuest ? 'GROUP' : 'SOLO',
                            style: const TextStyle(
                              color: Color(0xFF00B2AA),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Expires in ${widget.quest.expiresIn}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.42),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFEB5D4F).withOpacity(0.30),
                        const Color(0xFF050608),
                        const Color(0xFF00B2AA).withOpacity(0.26),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: isRecording ? stopRecording : startRecording,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRecording
                              ? const Color(0xFFFF6B5E)
                              : const Color(0xFF101216),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B5E).withOpacity(0.25),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Icon(
                          isRecording
                              ? Icons.stop_rounded
                              : hasRecording
                              ? Icons.graphic_eq_rounded
                              : Icons.mic_rounded,
                          color: Colors.white,
                          size: 46,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Text(
                isRecording
                    ? 'Recording... tap to stop'
                    : hasRecording
                    ? 'Audio ready to post'
                    : 'Tap the mic to record',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF101216),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: TextField(
                  controller: captionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  minLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a caption...',
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: hasRecording ? postAudio : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7668),
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white12,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'POST',
                        style: TextStyle(fontWeight: FontWeight.w900),
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