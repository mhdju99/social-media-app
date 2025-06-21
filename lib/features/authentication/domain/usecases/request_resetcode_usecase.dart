// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

class RequestResetcodeUsecase {
    final AuthenticationRepository authenticationRepository;
  RequestResetcodeUsecase({
    required this.authenticationRepository,
  });

   Future<Either<Failure,void >> call(String email) {
    return authenticationRepository.requestResetCode(email: email);
  }
}
