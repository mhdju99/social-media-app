import 'package:social_media_app/features/realtime/domain/entities/notification_entity.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}
class Notificationloading extends NotificationState {}

class NotificationUpdated extends NotificationState {
  final List<Map<String, dynamic>> notifications;

  NotificationUpdated(this.notifications);
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  NotificationLoaded(this.notifications);
}
