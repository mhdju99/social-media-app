// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/src/form_data.dart';
import 'package:flutter/foundation.dart';

import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:social_media_app/features/authentication/data/data_sources/authentication_remot_data_source.dart';
import 'package:social_media_app/features/authentication/data/models/user_model/user_model.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

/// AuthenticationRepositoryImpl is the concrete implementation of the AuthenticationRepository
/// interface.
/// This class implements the methods defined in AuthenticationRepository to interact
/// with data. It acts as a bridge between the domain layer
/// (use cases) and the data layer (data sources).
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemotDataSource remot;
  final AuthenticationLocalDataSource local;
  AuthenticationRepositoryImpl({
    required this.remot,
    required this.local,
  });

  @override
  Future<bool> isUserLogIn() async {
    final String? token = await local.getToken();
    final result = token != null && token.isNotEmpty;
    return result;
  }

  @override
  Future<Either<Failure, UserEntity>> logIn(
      {required String email, required String password}) async {
    try {
      final UserModel user = await remot.login(email, password);
      // await local.saveToken(user.)
      return right(user.toEntity());
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<void> logOut() async {
    await local.delToken();
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      {required String userName,
      required bool certifiedDoctor,
      required String firstName,
      required String lastName,
      required String birthDate,
      required String email,
      required String password,
      required String country,
      required String city,
      required List<String> preferredTopics}) async {
    try {
      final userModel = await remot.register(
        userName: userName,
        certifiedDoctor: certifiedDoctor,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        email: email,
        password: password,
        country: country,
        city: city,
        preferredTopics: preferredTopics,
      );
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } 
  }

  @override
 Future<Either<Failure, void>> resetPassword(
      {required String newPassword, required String token}) async {
 try {
      await remot.resetPassword(newPassword: newPassword,token: token);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
  
  @override
  Future<Either<Failure, void>> requestResetCode(
      {required String email}) async{
    try {
      await remot.requestResetCode(email);
      return right(null);
    } on ServerException catch (e) {
      return right(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
  
  @override
  Future<Either<Failure, String>> verifyResetCode(
      {required String email, required String code}) async {
    try {
              debugPrint("aaaaaaaaaaaaaaaaaa ${email}");

    final  token=  await remot.verifyResetCode(code: code,email: email);
      return right(token);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> addProfailImage(
      {required File file}) async {
    try {
      await remot.addProfileImage(file: file);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
  }



