import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    var androidInit = const AndroidInitializationSettings(
        '@drawable/ic_stat_onesignal_default');
    var iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    var initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  NotificationDetails getNotificationDetails() {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'Android_Channel_Id',
      'Android_Channel_Name',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/ic_stat_onesignal_default',
      playSound: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
  }

  Future<void> showNotification(
      {int id = 0,
      required String title,
      required String body,
      String? payload}) async {
    var notificationDetails = getNotificationDetails();
    notificationsPlugin.show(id, title, body, notificationDetails);
  }

  Future<void> scheduleNotification(
      {int id = 0,
      required String title,
      required String body,
      required int seconds}) async {
    var notificationDetails = getNotificationDetails();
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
