import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificacionesService {
  static final FlutterLocalNotificationsPlugin _noti =
      FlutterLocalNotificationsPlugin();

  /// Solicita permisos de exact alarms en Android 12+
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

  /// Solicita permisos de notificaciones
  Future<void> solicitarPermisosNotificaciones() async {
    if (Platform.isAndroid) {
      await solicitarPermisoExactAlarms();
    } else if (Platform.isIOS) {
      await Permission.notification.request();
    }
  }

  /// Inicializa el plugin y crea canal de Android
  Future<void> init() async {
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS / macOS settings
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialization settings para todas las plataformas
    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
      macOS: iosInit,
    );

    await _noti.initialize(settings);

    // Crear canal de notificaciones en Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'canal_recordatorios',
      'Recordatorios',
      importance: Importance.high,
    );

    final androidImplementation = _noti
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(channel);
  }

  /// Mostrar notificación instantánea
  Future<void> mostrarNotificacion(String titulo, String cuerpo) async {
    const androidDetails = AndroidNotificationDetails(
      'canal_recordatorios',
      'Recordatorios',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    await _noti.show(
      0,
      titulo,
      cuerpo,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Programar notificación a una fecha y hora específica
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

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _noti.zonedSchedule(
      notificationId,
      titulo,
      cuerpo,
      tz.TZDateTime.from(fechaHora, tz.local),
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
