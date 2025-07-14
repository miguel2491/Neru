import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/widgets/audio.dart';
import 'package:neru/widgets/boton.dart';
import 'package:audioplayers/audioplayers.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neru'),
        centerTitle: true,
        backgroundColor: Color(0xFFBF4141),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/fondo.png',
            ), // Aquí pones tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 32),
            AudioPlayButton(
              assetPath: 'audio/muscular.mp3',
              label: 'Escuchar explicación',
            ),
            const SizedBox(height: 32),
            const Text(
              '¿Estats listo para aumentar tu rendimiento DEPORTIVO?',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
