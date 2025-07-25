import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';

class StreamUserOnlineUseCase {
  final RealtimeRepository repository;

  StreamUserOnlineUseCase(this.repository);

  Stream<String> call() {
    return repository.userOnline;
  }
}
