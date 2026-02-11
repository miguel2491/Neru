import 'dart:async';
import 'dart:developer';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../services/noti_service.dart';

class MyTaskHandler extends TaskHandler {
  final Map<String, Timer> _timer = {};
  DateTime? _last50min;
  DateTime? _last3h;
  DateTime? _last12h;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Timer cada 50 minutos
    log("🔥 Foreground Service INICIADO");
    // _timer['noti1'] = Timer.periodic(const Duration(minutes: 50), (_) async {
    //   await NotificationService.show(
    //     "🧠✨ ¡Entrena tu mente hoy! ",
    //     "Solo 5 minutos pueden marcar la diferencia.",
    //   );
    // });
    // // Timer 2: cada 180 minutos
    // _timer['noti2'] = Timer.periodic(const Duration(minutes: 180), (_) async {
    //   await NotificationService.show(
    //     "🎯 Recuerda tu objetivo: ",
    //     "cada día que entrenas, estás más cerca de lograrlo.",
    //   );
    // });

    // // Timer 3: cada 30 segundos (solo para ejemplo rápido)
    // _timer['noti3'] = Timer.periodic(const Duration(hours: 12), (_) async {
    //   await NotificationService.show(
    //     "🔄 Tu constancia es tu fuerza.",
    //     "¿Ya hiciste tu ejercicio mental de hoy?",
    //   );
    // });
    // // Timer 4: cada 12 Horas (solo para ejemplo rápido)
    // _timer['noti4'] = Timer.periodic(const Duration(hours: 4), (_) async {
    //   await NotificationService.show(
    //     "🕒 Es momento de pausar... y entrenar tu mente.",
    //     " ",
    //   );
    // });
    // // Timer 5: cada 20h
    // _timer['noti5'] = Timer.periodic(const Duration(hours: 20), (_) async {
    //   await NotificationService.show(
    //     "💡 La mente también se fortalece.",
    //     "¡Haz tu práctica diaria!",
    //   );
    // });
    // // Timer 6: cada  5 Hrs
    // _timer['noti6'] = Timer.periodic(const Duration(hours: 5), (_) async {
    //   await NotificationService.show(
    //     "📈 El éxito comienza en tu cabeza. ",
    //     "No te saltes tu sesión mental.",
    //   );
    // });
    // _timer['noti7'] = Timer.periodic(const Duration(hours: 5), (_) async {
    //   await NotificationService.show(
    //     "🧘‍♂️ Respira, enfócate y actúa.",
    //     "Tu mente necesita atención diaria.",
    //   );
    // });
    // _timer['noti8'] = Timer.periodic(const Duration(hours: 12), (_) async {
    //   await NotificationService.show(
    //     "⚡ Activa tu mente, activa tu día.",
    //     "¡Haz tu ejercicio mental ahora!",
    //   );
    // });
    // _timer['noti9'] = Timer.periodic(const Duration(hours: 5), (_) async {
    //   await NotificationService.show(
    //     "🧭 Tu enfoque guía tu camino.",
    //     "¿Ya entrenaste tu atención hoy?",
    //   );
    // });
    // _timer['noti10'] = Timer.periodic(const Duration(hours: 20), (_) async {
    //   await NotificationService.show(
    //     "💭 Una mente entrenada toma mejores decisiones.",
    //     "¡Sigue avanzando!",
    //   );
    // });
    // _timer['noti11'] = Timer.periodic(const Duration(hours: 2), (_) async {
    //   await NotificationService.show(
    //     "🧘‍♀️ Mentalmente fuerte, emocionalmente estable. ",
    //     "No olvides tu práctica.",
    //   );
    // });
    // _timer['noti12'] = Timer.periodic(const Duration(hours: 5), (_) async {
    //   await NotificationService.show(
    //     "🧱 Cada día suma. ",
    //     "Hoy también construye tu fortaleza mental.",
    //   );
    // });
    // _timer['noti13'] = Timer.periodic(const Duration(hours: 1), (_) async {
    //   await NotificationService.show(
    //     "🔐 La clave del rendimiento está en tu mente.",
    //     "Entrénala.",
    //   );
    // });
    // _timer['noti14'] = Timer.periodic(const Duration(hours: 6), (_) async {
    //   await NotificationService.show(
    //     "🌟 No es magia, es entrenamiento.",
    //     "Hazlo parte de tu rutina.",
    //   );
    // });
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    final now = DateTime.now();

    if (_shouldRun(_last50min, now, const Duration(minutes: 50))) {
      _last50min = now;
      await NotificationService.show(
        "🧠✨ ¡Entrena tu mente hoy!",
        "Solo 5 minutos pueden marcar la diferencia.",
      );
    }

    if (_shouldRun(_last3h, now, const Duration(hours: 3))) {
      _last3h = now;
      await NotificationService.show(
        "🎯 Recuerda tu objetivo",
        "Cada día cuenta.",
      );
    }

    if (_shouldRun(_last12h, now, const Duration(hours: 12))) {
      _last12h = now;
      await NotificationService.show(
        "🧘‍♂️ Tu mente necesita atención diaria",
        "Haz tu ejercicio mental.",
      );
    }
  }

  bool _shouldRun(DateTime? last, DateTime now, Duration interval) {
    if (last == null) return true;
    return now.difference(last) >= interval;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    log("🛑 Foreground service DETENIDO");
    await FlutterForegroundTask.restartService();
    // _timer.forEach((key, timer) => timer.cancel());
    // _timer.clear();
  }
}

class ForegroundService {
  static Future<void> init() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'fg_task',
        channelName: 'Comenzamos',
        channelDescription: 'Bienvenido a Neru',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(60000),
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<ServiceRequestResult> start() {
    return FlutterForegroundTask.startService(
      notificationTitle: 'Neru',
      notificationText: '⚽Bienvenido a Neru',
      callback: startCallback,
    );
  }

  static Future<ServiceRequestResult> stop() {
    return FlutterForegroundTask.stopService();
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}
