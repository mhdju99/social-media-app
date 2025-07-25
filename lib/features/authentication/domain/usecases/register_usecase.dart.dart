import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/authentication/domain/params/register_params.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

class RegisterUseCase {
  final AuthenticationRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(
      gender: params.gender,
      userName: params.userName,
      certifiedDoctor: params.certifiedDoctor,
      firstName: params.firstName,
      lastName: params.lastName,
      birthDate: params.birthDate,
      email: params.email,
      password: params.password,
      country: params.country,
      city: params.city,
      preferredTopics: params.preferredTopics,
    );
  }
}
