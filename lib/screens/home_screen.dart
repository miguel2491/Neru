import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/main.dart';
import 'package:neru/screens/inicio/intro_psic.dart';
import 'package:neru/screens/inicio/intro_slider.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/login/login_screen.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/progreso.dart';
import 'package:neru/services/db_helper.dart';
import 'package:neru/services/notificaciones.dart';
import 'package:neru/widgets/bottom_nav.dart';
//import '../widgets/app_drawer.dart';
import 'package:neru/widgets/boton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VariablesScreen()),
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

  final List<Widget> _pages = [
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Progreso", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Home", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Calendario", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Perfil", style: TextStyle(color: Colors.white)),
    ),
  ];
  Future<void> solicitarPermisoExactAlarms() async {
    if (Platform.isAndroid) {
      final plugin = FlutterLocalNotificationsPlugin();
      final androidImplementation = plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final permitido = await androidImplementation
          ?.canScheduleExactNotifications();
      if (permitido == false) {
        await androidImplementation?.requestExactAlarmsPermission();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea el título a la derecha
          children: [Text('NERU')],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.close),
        //     onPressed: () {
        //
        //         },
        //       );
        //     },
        //   ),
        // ],
      ),
      // drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          print('FAB presionado');
          // Puedes navegar a otra pantalla si quieres
          // Navigator.push(context, MaterialPageRoute(builder: (_) => OtraPantalla()));
        },
        child: const Icon(Icons.help),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),
            Image.asset('assets/logo.png', height: 150),
            const SizedBox(height: 4),
            const Text(
              'Bienvenido',
              style: TextStyle(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: '¿Que es la psicología del deporte?',
              icon: FaIcon(
                FontAwesomeIcons.headset,
                color: Colors.white,
                size: 20,
              ),
              color: const Color(0xFFBF4141),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroScreen()),
                );
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Iniciar Entrenamiento mental',
              icon: FaIcon(
                FontAwesomeIcons.brain,
                color: Colors.white,
                size: 20,
              ),
              color: const Color(0xFFBF4141),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroSlider()),
                );
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Contacta un psicologo en el deporte',
              icon: FaIcon(
                FontAwesomeIcons.phone,
                color: Colors.white,
                size: 20,
              ),
              color: const Color(0xFFBF4141),
              onPressed: () {
                Navigator.pushNamed(context, '/progreso');
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Chat IA (Próximamente)',
              icon: FaIcon(
                FontAwesomeIcons.comment,
                color: Colors.white,
                size: 20,
              ),
              color: const Color(0xFF616161),
              onPressed: () async {
                final plugin = FlutterLocalNotificationsPlugin();
                final androidImplementation = plugin
                    .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin
                    >();

                final permitido = await androidImplementation
                    ?.canScheduleExactNotifications();

                print("🔍 ¿Puede programar alarmas exactas?: $permitido");

                final ahora = DateTime.now().add(const Duration(seconds: 50));
                await notiService.programarNotificacion(
                  "⏰ Recordatorio",
                  "¡Es hora de tu lección 🗓️",
                  ahora,
                );
                await notiService.mostrarNotificacion(
                  "TEST",
                  "Notificación instantánea",
                );
                print("✅ Notificación programada");
              },
            ),
            const SizedBox(height: 32),
            _pages[_selectedIndex],
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
