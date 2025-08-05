import 'package:flutter/material.dart';
import 'package:neru/screens/login/check_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import './services/notificaciones.dart';

final NotificacionesService notiService = NotificacionesService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await notiService.init();

  // 🔹 Pedir permiso para notificaciones
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // 🔹 Pedir permiso para alarmas exactas (Android 12+)
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
  await notiService.mostrarNotificacion(
    "🔔 Bienvenido ⚽",
    "Comienza con tu lección diaria, vamos",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NERU',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: const Color(0xFF494859),
        fontFamily: 'Monserrat',
      ),
      home: CheckAuthScreen(),
    );
  }
}
