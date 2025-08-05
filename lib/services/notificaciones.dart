import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificacionesService {
  static final FlutterLocalNotificationsPlugin _noti =
      FlutterLocalNotificationsPlugin();

  Future<void> solicitarPermisoExactAlarms() async {
    if (Platform.isAndroid) {
      final androidImplementation = _noti
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

  Future<void> solicitarPermisosNotificaciones() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
    );

    await _noti.initialize(settings);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'canal_recordatorios', // debe coincidir con el ID que usas en las notificaciones
      'Recordatorios',
      importance: Importance.high,
    );

    final androidImplementation = _noti
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(channel);
  }

  // 🔹 Notificación instantánea
  Future<void> mostrarNotificacion(String titulo, String cuerpo) async {
    const androidDetails = AndroidNotificationDetails(
      'canal_recordatorios', // ✅ Debe ser el mismo que creas en init()
      'Recordatorios',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _noti.show(
      0,
      titulo,
      cuerpo,
      const NotificationDetails(android: androidDetails),
    );
  }

  // 🔹 Notificación programada (recordatorio)
  Future<void> programarNotificacion(
    String titulo,
    String cuerpo,
    DateTime fechaHora,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'canal_recordatorios',
      'Recordatorios',
      importance: Importance.high,
      priority: Priority.high,
    );
    print("📅 Programando notificación para: $fechaHora");
    print("Ahora es: ${DateTime.now()}");
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _noti.zonedSchedule(
      notificationId,
      titulo,
      cuerpo,
      tz.TZDateTime.from(fechaHora, tz.local),
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
