import 'package:social_media_app/features/realtime/domain/entities/notification_entity.dart';

abstract class NotificationEvent {}

class NewNotificationReceived extends NotificationEvent {
  final Map<String, dynamic> notificationData;

  NewNotificationReceived(this.notificationData);
}

class AddNotificationEvent extends NotificationEvent {
  final Map<String, dynamic> notification;

  AddNotificationEvent(this.notification);
}

class LoadNotificationsEvent extends NotificationEvent {}

class MarkNotificationAsReadEvent extends NotificationEvent {

  MarkNotificationAsReadEvent();
}
