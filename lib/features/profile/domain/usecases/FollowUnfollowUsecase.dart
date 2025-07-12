import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';

class FollowUnfollowUsecase {
  final ProfileRepository repository;

  FollowUnfollowUsecase(this.repository);

  Future<Either<Failure, void>> call(String userId) {
    return repository.followUnfollowUser(userId: userId);
  }
}
