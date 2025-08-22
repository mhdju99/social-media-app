import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';


class DisconnectSocket {
  final RealtimeRepository repository;

  DisconnectSocket(this.repository);

  void call() {repository.disconnect();} 
}
