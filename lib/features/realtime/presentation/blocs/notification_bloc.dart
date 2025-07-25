import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/notifications_service.dart';
import 'package:social_media_app/features/realtime/domain/usecases/cache_notification.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_all_notifications.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_notifications_streams.dart';
import 'package:social_media_app/features/realtime/domain/usecases/mark_as_read.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final List<Map<String, dynamic>> _notifications = [];
  final GetNotificationsStreamsUseCase getNotificationsStreamsUseCase;
  final CacheNotificationUseCase cacheNotification;
  final GetAllNotificationsUseCase getAll;
  final MarkAsReadUseCase markAsRead;
  NotificationBloc(
      {required this.cacheNotification,
      required this.getAll,
      required this.markAsRead,
      required this.getNotificationsStreamsUseCase})
      : super(NotificationInitial()) {
    // عند استلام إشعار جديد من السيرفر (Socket)
    on<NewNotificationReceived>((event, emit) async {
      // أضف الإشعار للقائمة
      _notifications.insert(0, event.notificationData);
      emit(NotificationUpdated(List.from(_notifications)));

      // عرض الإشعار باستخدام flutter_local_notifications
      await NotificationService.showNotification(
        title: event.notificationData['userName'] ?? 'إشعار جديد',
        body: event.notificationData['text'] ?? '',
      );
    });
    on<AddNotificationEvent>((event, emit) async {
      await cacheNotification(event.notification);
      print("💥");
      print(event.notification);
      add(LoadNotificationsEvent());
    });
    on<LoadNotificationsEvent>((event, emit) async {
            emit(Notificationloading());

      final notifications = await getAll();
        notifications.sort((a, b) => b.date.compareTo(a.date));

      emit(NotificationLoaded(notifications));
    });

    on<MarkNotificationAsReadEvent>((event, emit) async {
      await markAsRead();
      add(LoadNotificationsEvent());
    });

    // الاستماع لبث الإشعارات الجديدة من السيرفر
    getNotificationsStreamsUseCase.newNotif.listen((notif) {
      add(NewNotificationReceived(notif));
    });

    // تحميل الإشعارات الأولية (عند فتح التطبيق)
    getNotificationsStreamsUseCase.initial.listen((list) {
      for (var notif in list) {
        add(NewNotificationReceived(Map<String, dynamic>.from(notif)));
      }
    });
  }
}
