import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/domain/params/register_params.dart';

/// AuthenticationRepository is an abstract class defining the contract for operations
/// related to data within the domain layer.
/// Concrete implementations of this repository interface will be provided
/// in the data layer to interact with specific data sources (e.g., API, database).
abstract class AuthenticationRepository {
  Future<Either<Failure, UserEntity>> logIn({required String email, required String password});
  Future<Either<Failure, UserEntity>> register({
    required String userName,
    required bool certifiedDoctor,
    required String firstName,
    required String lastName,
    required String birthDate,
    required String email,
    required String password,
    required String country,
    required String city,
    required List<String> preferredTopics,
  });
  Future<void> logOut();
  Future<bool> isUserLogIn();
  Future<Either<Failure, void>> requestResetCode({required String email});
  Future<Either<Failure, String>> verifyResetCode({required String email, required String code});
Future<Either<Failure, void>> resetPassword({required String newPassword, required String token});
Future<Either<Failure, void>> addProfailImage({required File file});

}
