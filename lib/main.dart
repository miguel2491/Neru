import 'package:flutter/material.dart';
import 'package:neru/screens/login/check_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:neru/services/foreground_service.dart';
import 'package:neru/services/noti_service.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  //************************************************************************* */
  await NotificationService.init();
  // Iniciar servicio en segundo plano
  await ForegroundService.init();
  await ForegroundService.start();

  // Notificación inmediata de prueba
  // await noti.mostrarNotificacion("Listo", "El servicio está activo");
  //************************************************************************* */
  // 🔹 Pedir permiso para notificaciones
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // 🔹 Pedir permiso para alarmas exactas (Android 12+)
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NERU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00406a),
          foregroundColor: Colors.white,
        ),
        // 👇 Aquí defines la fuente y tamaños por defecto
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
          bodySmall: TextStyle(fontSize: 12, color: Colors.white),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        fontFamily:
            "Roboto", // 👈 aquí puedes cambiar por otra (ej: Montserrat)
      ),
      home: CheckAuthScreen(),
    );
  }
}
