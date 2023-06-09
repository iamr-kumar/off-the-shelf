// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final notificationService = NotificationService();
  notificationService.init();
  return notificationService;
});

class NotificationService {
  static const ANDROID_CHANNEL_ID = '0';
  static const ANDROID_CHANNEL_NAME = 'general';
  static const NOTIFICATION_ID = 0;
  static const NOTIFICATION_TITLE = 'It\'s time to read!';
  static const NOTIFICATION_BODY =
      'Pick up your book and complete your daily goal.';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('app_icon');

  final DarwinInitializationSettings _darwinInitializationSettings =
      const DarwinInitializationSettings();

  Future<void> init() async {
    await _configureLocalTimeZone();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _darwinInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  tz.TZDateTime _convertTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  void scheduleReminder(TimeOfDay time) async {
    final pendingRequestLength = await getPendingNotificationRequests();
    if (pendingRequestLength > 0) {
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      ANDROID_CHANNEL_ID,
      ANDROID_CHANNEL_NAME,
      priority: Priority.high,
      importance: Importance.max,
    );
    const iOSNotificationDetail = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSNotificationDetail,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      NOTIFICATION_ID,
      NOTIFICATION_TITLE,
      NOTIFICATION_BODY,
      _convertTime(time),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void cancelAndRescheduleReminder(TimeOfDay time) async {
    await cancelAllReminders();
    scheduleReminder(time);
  }

  Future<void> cancelAllReminders() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelById(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<int> getPendingNotificationRequests() async {
    final pendingRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingRequests.length;
  }
}
