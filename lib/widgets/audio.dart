import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayButton extends StatefulWidget {
  final String url;
  final String label;
  final Color color;

  const AudioPlayButton({
    super.key,
    required this.url,
    required this.label,
    required this.color,
  });

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(widget.url);
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // 🔹 Detener audio antes de liberar
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _togglePlayback,
      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
      label: Text(widget.label),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
    );
  }
}
