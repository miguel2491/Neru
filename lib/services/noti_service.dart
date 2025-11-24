import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    await _plugin.initialize(initSettings);
  }

  static Future<void> show(String title, String body) async {
    const android = AndroidNotificationDetails(
      'fg_channel',
      'Foreground Service',
      channelDescription: 'Notificaciones del servicio',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    await _plugin.show(
      1,
      title,
      body,
      const NotificationDetails(android: android),
    );
  }
}
