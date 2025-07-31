import 'package:hive/hive.dart';
import 'package:social_media_app/core/constants/box_keys.dart';
import '../models/notification_model.dart';

class LocalNotificationDataSource {
  Future<void> cacheNotification(NotificationModel model) async {
    final box = await Hive.openBox<NotificationModel>(BoxKeys.notifications);
    await box.add(model);
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    final box = await Hive.openBox<NotificationModel>(BoxKeys.notifications);
    return box.values.toList();
  }

  Future<void> markAsRead() async {
    final box = await Hive.openBox<NotificationModel>(BoxKeys.notifications);
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item != null && item.isRead == false) {
        final updatedItem = item.copyWith(isRead: true);
        await box.putAt(i, updatedItem);
      }
    }
  }
}
