
import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/params/ResetPassword_params.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

class ResetpasswordUsecase {
  final AuthenticationRepository authenticationRepository;
  ResetpasswordUsecase({
    required this.authenticationRepository,
  });
Future<Either<Failure, void>> call({ required String newPassword,required String token}) {
    return authenticationRepository.resetPassword(newPassword: newPassword,token:token);
  }  
}