import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';
import 'package:social_media_app/features/profile/data/models/user_model.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
/// ProfileDataSource is an abstract class defining the contract for fetching
/// data from various sources.
/// This abstract class outlines the methods that concrete data source
/// implementations should implement, such as fetching data from a remote API, local database, or any other data source.
abstract class ProfileDataSource {
  Future<UserProfileModel> getUserProfile({required String userId});
  Future<List<UserModel>> getprofilePhotoAndName(
      {required List<String> userId});

  Future<void> followUnfollowUser({required String userId});
  Future<void> blockUnblock({required String userId});
  Future<void> changepassword(
      {required String oldPassword, required String newPassword});
  Future<void> modifyprofile(
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

/// ProfileDataSourceImpl is the concrete implementation of the ProfileDataSource
/// interface.
/// This class implements the methods defined in ProfileDataSource to fetch
/// data from a remote API or other data sources.
class ProfileDataSourceImpl implements ProfileDataSource {
  final ApiConsumer api;
  // final AuthenticationLocalDataSource local;

  ProfileDataSourceImpl({
    required this.api,
    // required this.local,
  });

  @override
  Future<void> blockUnblock({required String userId}) async {
    await api
        .put(EndPoints.blockunblockEndPoint, data: {"targetUserId": userId});
  }

  @override
  Future<void> changepassword(
      {required String oldPassword, required String newPassword}) async {
    await api.put(EndPoints.changepasswordEndPoint,
        data: {"oldPassword": oldPassword, "newPassword": newPassword});
  }

  @override
  Future<void> followUnfollowUser({required String userId}) async {
    await api
        .put(EndPoints.followunfollowEndPoint, data: {"targetUserId": userId});
  }

  @override
  Future<UserProfileModel> getUserProfile({required String userId}) async {
    Response response = await api.get(EndPoints.getusersprofileEndPoint,
        queryParameters: {"userId": userId});
    UserProfileModel userProfileModel =
        UserProfileModel.fromResponse(response.data);
    return userProfileModel;
  }

  @override
  Future<List<UserModel>> getprofilePhotoAndName(
      {required List<String> userId}) async {
    Response response = await api.get(EndPoints.getnameimageEndPoint,
        queryParameters: {"usersIds": userId.join('-')});

    List<UserModel> userModel = [];
    userModel = (response.data["users"] as List)
        .map((userJson) => UserModel.fromJson(userJson))
        .toList();
    // UserModel.fromResponse(response.data);
    return userModel;
  }

  @override
  Future<void> modifyprofile(
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
final Map<String, dynamic> data = {};

    if (userName != null) data['userName'] = userName;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (birthDate != null) data['birthDate'] = birthDate;
    if (email != null) data['email'] = email;
    if (country != null) data['country'] = country;
    if (city != null) data['city'] = city;
    if (about != null) data['about'] = about;
    if (preferredTopics != null && preferredTopics.isNotEmpty) {
      data['preferredTopics'] = preferredTopics;
    }

        final formData = FormData.fromMap(data);

    await api.patch(
      EndPoints.ModifyProfileEndPoint,data: formData
    );
  }
}
