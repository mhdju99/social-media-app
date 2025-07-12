// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

class AddProfileImageUsecase {
  final AuthenticationRepository repository;
  AddProfileImageUsecase({
    required this.repository,
  });

  Future<Either<Failure, void>> call(File file) {
    return repository.addProfailImage(
      file: file,
    );
  }
}
