import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/main.dart';
import 'package:neru/screens/inicio/intro_psic.dart';
import 'package:neru/screens/inicio/intro_slider.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/widgets/bottom_nav.dart';
//import '../widgets/app_drawer.dart';
import 'package:neru/widgets/boton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 1;
  bool _encuestaMostrada = false;

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

  @override
  void initState() {
    super.initState();
    _verificarEncuesta();
  }

  Future<void> _verificarEncuesta() async {
    final prefs = await SharedPreferences.getInstance();
    final yaRespondio = prefs.getBool('encuestaRespondida') ?? false;

    if (!yaRespondio) {
      // Esperamos un poco para que cargue la UI
      Future.delayed(const Duration(seconds: 1), () {
        _mostrarEncuesta(context);
      });
    }
  }

  void _mostrarEncuesta(BuildContext context) {
    int _rating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Encuesta de satisfacción"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("¿Qué tan satisfecho estás con la app?"),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('encuestaRespondida', true);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "¡Gracias por tu calificación de $_rating estrellas!",
                        ),
                      ),
                    );
                  },
                  child: const Text("Enviar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final List<Widget> _pages = [
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    // Center(
    //   child: Text("Progreso", style: TextStyle(color: Colors.white)),
    // ),
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
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
              icon: Image.asset(
                'assets/iconos/i_psico.png',
                width: 24,
                height: 24,
                color: Colors
                    .white, // opcional, si la imagen es un ícono PNG blanco y negro
              ),
              color: const Color(0xFFff4000),
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
              color: const Color(0xFFff4000),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroSlider()),
                );
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Contacta un psicologo en el deporte (Próximamente)',
              icon: FaIcon(
                FontAwesomeIcons.phone,
                color: Colors.white,
                size: 20,
              ),
              color: const Color(0xFF616161),
              onPressed: () {
                //Navigator.pushNamed(context, '/progreso');
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Chat AI (Próximamente)',
              icon: Image.asset(
                'assets/iconos/i_chat.png',
                width: 24,
                height: 24,
                color: Colors
                    .white, // opcional, si la imagen es un ícono PNG blanco y negro
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
