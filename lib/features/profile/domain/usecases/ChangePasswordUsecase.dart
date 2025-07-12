import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';

class ChangePasswordUsecase {
  final ProfileRepository repository;

  ChangePasswordUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String oldPassword,
    required String newPassword,
  }) {
    return repository.changepassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
