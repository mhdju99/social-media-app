import 'package:social_media_app/features/realtime/data/data_sources/local_notification_datasource.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final LocalNotificationDataSource localDataSource;

  NotificationRepositoryImpl(this.localDataSource);

  @override
Future<void> cacheNotification(Map<String, dynamic> data) async {
    final model = NotificationModel.fromJson(data);
    await localDataSource.cacheNotification(model);
  }

  @override
  Future<List<NotificationEntity>> getAllNotifications() {
    return localDataSource.getAllNotifications();
  }

  @override
  Future<void> markAsRead() async {
    await localDataSource.markAsRead();
  }
}
