import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> cacheNotification(Map<String, dynamic> data);
  Future<List<NotificationEntity>> getAllNotifications();
  Future<void> markAsRead();
}
