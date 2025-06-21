import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/utils/logger.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio});

//!POST
  @override
  Future post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? header,
      bool isFormData = false}) async {
    try {
      var res = await dio.post(path,
          data: isFormData ? FormData.fromMap(data) : data,
          queryParameters: queryParameters,
          options: Options(
             validateStatus: (status) {
    return status != null && status >= 200 && status < 300;
  },
            headers: header,
            responseType: ResponseType.json,
          ));

      return res;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

//!GET
  @override
  Future get(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? header}) async {
    try {
      var res = await dio.get(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: header,
            responseType: ResponseType.json,
          ));

      return res;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

//!DELETE
  @override
  Future delete(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      var res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

//!PATCH
  @override
  Future patch(String path,
      {dynamic data,
      Map<String, dynamic>? header,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      var res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
