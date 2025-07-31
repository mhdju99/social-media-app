import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/params/ResetPassword_params.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

class ResetemailUsecase {
  final AuthenticationRepository authenticationRepository;
  ResetemailUsecase({
    required this.authenticationRepository,
  });
  Future<Either<Failure, void>> call(
      {required String newPassword}) {
    return authenticationRepository.changeemail(
       newPassword: newPassword);
  }
}
