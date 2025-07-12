import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUsecase {
  final ProfileRepository repository;

  GetUserProfileUsecase(this.repository);

  Future<Either<Failure, UserProfile>> call(String userId) {
    return repository.getUserProfile(userId: userId);
  }
}
