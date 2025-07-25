import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:social_media_app/features/profile/data/data_sources/profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<Either<Failure, void>> blockUnblock({required String userId}) async {
    try {
      await profileDataSource.blockUnblock(userId: userId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: "somthing wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> changepassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      await profileDataSource.changepassword(
          newPassword: newPassword, oldPassword: oldPassword);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: "somthing wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> followUnfollowUser(
      {required String userId}) async {
    try {
      await profileDataSource.followUnfollowUser(userId: userId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: "somthing wrong"));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(
      {required String userId}) async {
    try {
      final userProfileModel =
          await profileDataSource.getUserProfile(userId: userId);
      return right(userProfileModel.toEntity());
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getprofilePhotoAndName(
      {required List<String> userId}) async {
    try {
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      final List<UserModel> usersModel =
          await profileDataSource.getprofilePhotoAndName(userId: userId);
      print(usersModel.toString());

      List<User> users = [];
      users =
          (usersModel as List).map<User>((user) => user.toEntity()).toList();
      return right(users);
    } on ServerException catch (e) {
      print("💫");
      print(e.errorModel.errorMessage);

      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
            print("💫");
      print(a.toString());
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
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
      String? about}) async {
    // TODO: implement modifyprofile
    try {
      await profileDataSource.modifyprofile(
          about: about,
          birthDate: birthDate,
          city: city,
          country: country,
          email: email,
          firstName: firstName,
          lastName: lastName,
          photo: photo,
          preferredTopics: preferredTopics,
          userName: userName);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: "somthing wrong"));
    }
  }
}
