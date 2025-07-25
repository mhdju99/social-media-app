import '../repositories/notification_repository.dart';
import '../entities/notification_entity.dart';

class CacheNotificationUseCase {
  final NotificationRepository repository;

  CacheNotificationUseCase(this.repository);

  Future<void> call(Map<String, dynamic> notification) {
    return repository.cacheNotification(notification);
  }
}
