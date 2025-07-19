import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';


class ConnectToSocketUseCase {
  final RealtimeRepository repository;

  ConnectToSocketUseCase(this.repository);

  Future<void> call(String token) => repository.connect(token);
}
