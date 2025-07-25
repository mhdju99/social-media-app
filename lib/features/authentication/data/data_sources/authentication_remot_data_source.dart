// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/foundation.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/utils/logger.dart';
import 'package:social_media_app/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:social_media_app/features/authentication/data/models/user_model/user_model.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';

/// AuthenticationDataSource is an abstract class defining the contract for fetching
/// data from various sources.
/// This abstract class outlines the methods that concrete data source
/// implementations should implement, such as fetching data from a remote API, local database, or any other data source.
abstract class AuthenticationRemotDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String userName,
    required bool certifiedDoctor,
    required String firstName,
    required String lastName,
    required String birthDate,
    required String email,
    required String password,
    required String country,
    required String city,
    required String gender,
    required List<String> preferredTopics,
  });
  Future<void> requestResetCode(String email);
  Future<String> verifyResetCode({required String email, required String code});
  Future<void> addProfileImage({required File file});
  Future<void> resetPassword(
      {required String token, required String newPassword});

  Future<void> ChosePreferredTopics({required String Topic});
}

/// AuthenticationDataSourceImpl is the concrete implementation of the AuthenticationDataSource
/// interface.
/// This class implements the methods defined in AuthenticationDataSource to fetch
/// data from a remote API or other data sources.
class AuthenticationRemotDataSourceImpl
    implements AuthenticationRemotDataSource {
  final ApiConsumer api;
  final AuthenticationLocalDataSource local;

  AuthenticationRemotDataSourceImpl({
    required this.api,
    required this.local,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    Response resposne = await api.get(
      await EndPoints.logInEndPoint,
      queryParameters: {'email': email},
      header: {
        "password": password,
      },
    );

    Map<dynamic, dynamic> resposneData = resposne.data;
    UserModel userData = UserModel.fromResponse(resposneData);
    final String? token = resposne.headers.value('authorization');
    if (token == null || token.isEmpty || userData == null) {
      throw Exception("Authorization token not found in response headers");
    }

    // ✅ خزّن التوكن محليًا
    await local.saveTokenSec(token);

    await local.saveData(userData.id!, "userID");

    return userData;
    // debugPrint("📤 الرابط النهائي: ${resposne.realUri}");

    // // ✅ خزّن التوكن محليًا
    // await local.saveToken(token);

    // return userData;
  }

  @override
  Future<UserModel> register(
      {required String userName,
      required bool certifiedDoctor,
      required String firstName,
      required String lastName,
      required String birthDate,
      required String email,
      required String password,
      required String country,
      required String city,
      required String gender,
      required List<String> preferredTopics}) async {
    Response resposne = await api.post(await EndPoints.registerEndPoint, data: {
      "userName": userName,
      "certifiedDoctor": certifiedDoctor,
      "firstName": firstName,
      "lastName": lastName,
      "birthDate": birthDate.toString(),
      "email": email,
      "location": {"country": country, "city": city},
      "preferredTopics": preferredTopics,
      "gender": gender,
    }, header: {
      "password": password,
    });
    Map<String, dynamic> resposneData = resposne.data;
    print("☮$resposneData");
    UserModel userData = UserModel.fromResponse(resposneData);
    final String? token = resposne.headers.value('authorization');
    if (token == null || token.isEmpty) {
      throw Exception("Authorization token not found in response headers");
    }

    // ✅ خزّن التوكن محليًا
    await local.saveTokenSec(token);
    await local.saveData(userData.id!, "userID");

    return userData;
  }

  @override
  Future<void> requestResetCode(String email) async {
    var res = await api.get(
      await EndPoints.requestResetCodeEndPoint,
      queryParameters: {"email": email},
    );
  }

  @override
  Future<void> resetPassword(
      {required String token, required String newPassword}) async {
    await api.get(
      await EndPoints.requestResetCodeEndPoint,
      queryParameters: {"password": newPassword},
      header: {
        "token": token,
      },
    );
  }

  @override
  Future<void> addProfileImage({required File file}) async {
    print('📄 File name: ${file.path.split('/').last}');

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    });
    await api.post(
      isFormData: false,
      await EndPoints.addProfileImageEndPoint,
      data: formData,
      // header: {
      //   "token": token,
      // },
    );
  }

  Future<void> ChosePreferredTopics({required String Topic}) async {
    final formData = FormData.fromMap({'preferredTopics': Topic});
    await api.patch(
      await EndPoints.modifyProfileEndPoint,
      data: formData,
      // header: {
      //   "token": token,
      // },
    );
  }

  @override
  Future<String> verifyResetCode(
      {required String email, required String code}) async {
    Response resposne = await api.get(
      await EndPoints.verifyResetCodeEndPoint,
      queryParameters: {"email": email},
      header: {
        "code": code,
      },
    );
    final token = resposne.headers.value('token');
    if (token == null) {
      throw Exception('Authorization token not found in response headers');
    }
    return token;
  }
}
