import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PostMedia extends StatefulWidget {
  final String mediaType;
  final String? imageUrl;
  final String? audioUrl;

  const PostMedia({
    super.key,
    required this.mediaType,
    this.imageUrl,
    this.audioUrl,
  });

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingAudio = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    final audioUrl = widget.audioUrl?.trim();

    if (audioUrl == null || audioUrl.isEmpty) return;

    if (_isPlayingAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingAudio = false);
      return;
    }

    await _audioPlayer.play(UrlSource(audioUrl));
    setState(() => _isPlayingAudio = true);

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlayingAudio = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaType == 'audio') {
      return Container(
        height: 390,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFEB5D4F).withOpacity(0.22),
              const Color(0xFF050608),
              const Color(0xFF00B2AA).withOpacity(0.18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: _toggleAudio,
            child: Icon(
              _isPlayingAudio
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 92,
            ),
          ),
        ),
      );
    }

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        height: 390,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return const SizedBox(
      height: 390,
      child: Center(
        child: Text(
          'No media',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}