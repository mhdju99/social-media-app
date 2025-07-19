import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';
class GetNotificationsStreamsUseCase {
  final RealtimeRepository repository;

  GetNotificationsStreamsUseCase(this.repository);

  Stream<List<dynamic>> get initial => repository.initialNotifications;
  Stream<Map<String, dynamic>> get newNotif => repository.newNotification;
}
