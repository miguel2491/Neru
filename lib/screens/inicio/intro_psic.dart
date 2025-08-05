import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:neru/screens/entrenamiento.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/widgets/audio.dart';
import 'package:neru/widgets/bottom_nav.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final int _selectedIndex = 0;
  final player = AudioPlayer();

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EntrenamientoScreen()),
      );
      return; // no cambies _selectedIndex si navegas
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
      );
      return;
    }
  }

  @override
  void dispose() {
    player.stop(); // ✅ Se detiene cuando sales de la pantalla
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea el título a la derecha
          children: [Text('NERU')],
        ),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 20.0),
              child: Text(
                '¿Estas listo para aumentar tu rendimiento DEPORTIVO?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Monserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 84),
            AudioPlayButton(
              color: const Color(0xFFBF4141),
              url:
                  'https://gcconsultoresmexico.com/audios/psicologia_deporte.mp3',
              label: '¿Que es psicología del deporte?',
            ),
            const SizedBox(height: 32),

            AudioPlayButton(
              color: const Color(0xFFBF4141),
              url:
                  'https://gcconsultoresmexico.com/audios/psicologo_deportivo.mp3',
              label: '¿Por que ir con un psicologo deportivo?',
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
