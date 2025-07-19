import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';


class SendMessageUseCase {
  final RealtimeRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(String to, String content) =>
      repository.sendMessage(to, content);
}
