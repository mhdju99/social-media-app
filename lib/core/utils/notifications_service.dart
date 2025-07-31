import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_media_app/main.dart';

// استيراد navigatorKey من main.dart (قم بتعديل المسار حسب الحاجة)

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
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
    // ✅ منع الإشعار إذا كنت داخل صفحة ChatPage
    final context = navigatorKey.currentContext;
    final routeName = ModalRoute.of(context!)?.settings.name;

    if (routeName == '/chatPage') {
      print('📵 إشعار تم تجاهله لأن المستخدم في صفحة المحادثة');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'Channel for default notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',
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
