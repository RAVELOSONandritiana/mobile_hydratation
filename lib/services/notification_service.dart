import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final fln.FlutterLocalNotificationsPlugin _notificationsPlugin =
      fln.FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    final fln.AndroidInitializationSettings initializationSettingsAndroid =
        const fln.AndroidInitializationSettings('@mipmab/ic_launcher');

    final fln.InitializationSettings initializationSettings = fln.InitializationSettings(
      android: initializationSettingsAndroid,
      linux: const fln.LinuxInitializationSettings(defaultActionName: 'Open'),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap if needed
      },
    );
  }

  static Future<void> scheduleHourlyReminder() async {
    final fln.AndroidNotificationDetails androidPlatformChannelSpecifics =
        const fln.AndroidNotificationDetails(
      'hydration_id',
      'Hydration Reminders',
      channelDescription: 'Regular reminders to drink water',
      importance: fln.Importance.max,
      priority: fln.Priority.high,
    );

    final fln.NotificationDetails platformChannelSpecifics = fln.NotificationDetails(
      android: androidPlatformChannelSpecifics,
      linux: const fln.LinuxNotificationDetails(),
    );

    // Cancel existing one to avoid duplicates if re-enabled
    await cancelAll();

    // Schedule for every hour
    await _notificationsPlugin.periodicallyShow(
      0,
      'Time to hydrate! 💧',
      'Stay healthy by drinking a glass of water now.',
      fln.RepeatInterval.hourly,
      platformChannelSpecifics,
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
