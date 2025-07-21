import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayButton extends StatefulWidget {
  final String assetPath;
  final Color color;
  final String label;

  const AudioPlayButton({
    super.key,
    required this.assetPath,
    required this.label,
    this.color = Colors.teal,
  });

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  late AudioPlayer _player;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play(AssetSource(widget.assetPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      ),
      icon: Icon(
        isPlaying ? Icons.pause_circle : Icons.play_arrow,
        color: Colors.white,
        size: 32,
      ),
      label: Text(
        widget.label,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      onPressed: _toggleAudio,
    );
  }
}
