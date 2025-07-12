import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';

class BlockUnblockUsecase {
  final ProfileRepository repository;

  BlockUnblockUsecase(this.repository);

  Future<Either<Failure, void>> call(String userId) {
    return repository.blockUnblock(userId: userId);
  }
}
