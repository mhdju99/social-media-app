import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfilePhotoAndNameUsecase {
  final ProfileRepository repository;

  GetProfilePhotoAndNameUsecase(this.repository);

  Future<Either<Failure, User>> call(String userId) {
    return repository.getprofilePhotoAndName(userId: userId);
  }
}
