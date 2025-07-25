import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';

class StreamUserOfflineUseCase {
  final RealtimeRepository repository;

  StreamUserOfflineUseCase(this.repository);

  Stream<Map<String, dynamic>> call() {
    return repository.userOffline;
  }
}
