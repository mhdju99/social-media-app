import 'package:social_media_app/features/realtime/domain/entities/notification_entity.dart';

import '../repositories/notification_repository.dart';

class GetAllNotificationsUseCase {
  final NotificationRepository repository;

  GetAllNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() {
    return repository.getAllNotifications();
  }
}
