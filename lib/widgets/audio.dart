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

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Carga la URL al inicializar
    _audioPlayer.setUrl(widget.url);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    final playing = _audioPlayer.playing;
    if (playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final playing = state?.playing ?? false;

        IconData icon;
        if (state?.processingState == ProcessingState.loading ||
            state?.processingState == ProcessingState.buffering) {
          icon = Icons.hourglass_empty; // Indicador de carga
        } else if (!playing) {
          icon = Icons.play_arrow;
        } else if (state?.processingState != ProcessingState.completed) {
          icon = Icons.pause;
        } else {
          icon = Icons.replay; // Si terminó, mostrar replay
        }

        return ElevatedButton.icon(
          onPressed: _togglePlayback,
          icon: Icon(icon, size: 25),
          label: Text(widget.label),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Sin redondeo
            ),
          ),
        );
      },
    );
  }
}
