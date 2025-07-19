import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';
class GetMessageStreamUseCase {
  final RealtimeRepository repository;

  GetMessageStreamUseCase(this.repository);

  Stream<Map<String, dynamic>> call() => repository.messageStream;
}
