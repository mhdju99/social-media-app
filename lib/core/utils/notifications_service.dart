import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // استخدم أيقونة مناسبة موجودة في res/drawable
    const android = AndroidInitializationSettings('ic_notification');

    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification clicked: ${response.payload}');
      },
    );

    // إنشاء قناة إشعار
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'Channel for default notifications',
      importance: Importance.high,
    );

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'Channel for default notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification', // تأكد أنها موجودة في drawable
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'data_example',
    );
  }
}
