import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';

class ModifyProfileUsecase {
  final ProfileRepository repository;

  ModifyProfileUsecase(this.repository);

  Future<Either<Failure, void>> call({
    String? userName,
    File? photo,
    String? firstName,
    List<String>? preferredTopics,
    String? lastName,
    String? birthDate,
    String? email,
    String? country,
    String? city,
    String? about,
  }) {
    return repository.modifyprofile(
      about: about,
      birthDate: birthDate,
      city: city,
      country: country,
      email: email,
      firstName: firstName,
      lastName: lastName,
      photo: photo,
      preferredTopics: preferredTopics,
      userName: userName,
    );
  }
}
