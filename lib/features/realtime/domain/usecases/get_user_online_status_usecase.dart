import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';


class GetUserOnlineStatusUseCase {
  final RealtimeRepository repository;

  GetUserOnlineStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call(String targetUserId) {
    return repository.isUserOnline(targetUserId);
  }
}
