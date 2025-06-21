
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/params/VerifyCode_params.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

class VerifyResetCodeUseCase {
      final AuthenticationRepository authenticationRepository;
  VerifyResetCodeUseCase({
    required this.authenticationRepository,
  });

Future<Either<Failure, String >> call({required String email, required String code}) {
                debugPrint("aaaaaaaaaaaaaaaaaa ${email}");

    return authenticationRepository.verifyResetCode(email: email,code: code);
  }
}