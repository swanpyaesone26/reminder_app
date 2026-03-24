import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ─────────────────────────────────────
  // INITIALIZE
  // ─────────────────────────────────────
  Future<void> init() async {
    tz.initializeTimeZones();

    // Auto detect device timezone
    final localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    // Fixed for version 17.2.2 (Positional argument)
    await _plugin.initialize(initSettings);

    // Request permission (Android 13+)
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
  }

  // ─────────────────────────────────────
  // NOTIFICATION DETAILS
  // ─────────────────────────────────────
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'note_channel',
        'Note Reminders',
        channelDescription: 'Reminders for your notes',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  // ─────────────────────────────────────
  // SCHEDULE DAILY NOTIFICATION
  // ─────────────────────────────────────
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime tzScheduled = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    // Fixed for version 17.2.2 (5 Positional arguments + named)
    await _plugin.zonedSchedule(
      id,
      'Daily Reminder',
      title,
      tzScheduled,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ─────────────────────────────────────
  // SCHEDULE MONTHLY NOTIFICATION (1 day before at 9AM)
  // ─────────────────────────────────────
  Future<void> scheduleMonthlyNotification({
    required int id,
    required String title,
    required DateTime reminderDate,
  }) async {
    final oneDayBefore = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day - 1,
      9,
      0,
    );

    final tz.TZDateTime tzScheduled = tz.TZDateTime.from(
      oneDayBefore,
      tz.local,
    );

    // Fixed for version 17.2.2 (5 Positional arguments + named)
    await _plugin.zonedSchedule(
      id,
      'Monthly Reminder — Tomorrow!',
      title,
      tzScheduled,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ─────────────────────────────────────
  // CANCEL NOTIFICATION
  // ─────────────────────────────────────
  Future<void> cancelNotification(int id) async {
    // Fixed for version 17.2.2 (Positional argument)
    await _plugin.cancel(id);
  }
}
