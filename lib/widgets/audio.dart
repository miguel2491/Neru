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

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Para que el ícono pueda salirse del botón
          children: [
            // Botón principal (pill)
            ElevatedButton(
              onPressed: _togglePlayback,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            // Ícono superpuesto flotante
            Positioned(
              top: -30,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFF616161),
                child: IconButton(
                  icon: Icon(icon, color: Colors.white, size: 28),
                  onPressed: _togglePlayback,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
