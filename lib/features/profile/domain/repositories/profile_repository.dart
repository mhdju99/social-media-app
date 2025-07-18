import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';

/// ProfileRepository is an abstract class defining the contract for operations
/// related to data within the domain layer.
/// Concrete implementations of this repository interface will be provided
/// in the data layer to interact with specific data sources (e.g., API, database).
abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile({required String userId});
  Future<Either<Failure, List<User>>> getprofilePhotoAndName(
      {required List<String> userId});
  Future<Either<Failure, void>> followUnfollowUser({required String userId});
  Future<Either<Failure, void>> blockUnblock({required String userId});
  Future<Either<Failure, void>> changepassword(
      {required String oldPassword, required String newPassword});
  Future<Either<Failure, void>> modifyprofile(
      {String? userName,
      File? photo,
      String? firstName,
      List<String>? preferredTopics,
      String? lastName,
      String? birthDate,
      String? email,
      String? country,
      String? city,
      String? about});
}
