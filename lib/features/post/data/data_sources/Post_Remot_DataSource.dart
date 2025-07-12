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
import 'package:social_media_app/features/post/data/models/post_model/post_model.dart';

/// AuthenticationDataSource is an abstract class defining the contract for fetching
/// data from various sources.
/// This abstract class outlines the methods that concrete data source
/// implementations should implement, such as fetching data from a remote API, local database, or any other data source.
abstract class PostRemotDataSource {
  Future<void> createPost({
    required String topic,
    required bool reelFlag,
    required String describtion,
    required List<File> images,
  });
  Future<void> modifyPost({
            required String postId,

    required String topic,
    required String describtion,
    List<File>? images,
    List<String>? deleteImagesIds,
  });
  Future<void> deletePost({required String postId});
  Future<PostModel> getPostDetails({required String postId});
  Future<void> likeUnlikePost({required String postId});
  Future<void> addComment({
    required String postId,
    required String content,
  });
}

/// AuthenticationDataSourceImpl is the concrete implementation of the AuthenticationDataSource
/// interface.
/// This class implements the methods defined in AuthenticationDataSource to fetch
/// data from a remote API or other data sources.
class PostRemotDataSourceImpl implements PostRemotDataSource {
  final ApiConsumer api;
  // final AuthenticationLocalDataSource local;

  PostRemotDataSourceImpl({
    required this.api,
    // required this.local,
  });

  @override
  Future<void> addComment(
      {required String postId, required String content}) async {
    await api.post(EndPoints.addcommentEndPoint,
        data: {"postId": postId, "content": content, "repliedTo": ""});
  }

  @override
  Future<void> createPost(
      {required String topic,
      required bool reelFlag,
      required String describtion,
      required List<File> images}) async {
    final formData = FormData.fromMap({
      'topic': topic,
      'describtion': describtion,
      'reelFlag': reelFlag,
    });
    for (var image in images) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(image.path,
              contentType: MediaType('image', 'jpeg'),
              filename: image.path.split('/').last),
        ),
      );
    }
    await api.post(
      EndPoints.createpostEndPoint,
      data: formData,
    );
  }

  @override
  Future<void> deletePost({required String postId}) async {
    await api.delete(EndPoints.deletepostEndPoint,
        queryParameters: {"postId": postId});
  }

  @override
  Future<void> likeUnlikePost({required String postId}) async {
    await api.put(EndPoints.likeUnlikepostEndPoint, data: {"postId": postId});
  }

  @override
  Future<void> modifyPost(
      {
        required String topic,
        required String postId,
      required String describtion,
      List<File>? images,
      List<String>? deleteImagesIds}) async {
    final formData = FormData.fromMap({
      'topic': topic,
      'describtion': describtion,
      'deleteImagesIds': deleteImagesIds,
    });
            debugPrint(postId);

    if (images != null) {
      for (var image in images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(image.path,
                contentType: MediaType('image', 'jpeg'),
                filename: image.path.split('/').last),
          ),
        );
      }
    }
    await api.patch(
      EndPoints.updatepostEndPoint,
      data: formData,
       header: {
      "post-id":postId.toString(),
    }
    );
  }

  @override
  Future<PostModel> getPostDetails({required String postId}) async {
    Response response = await api
        .get(EndPoints.getpostEndPoint, queryParameters: {"postId": postId});
           Map<String, dynamic> resposneData = response.data;
    PostModel postModel = PostModel.fromResponse(resposneData);
    return postModel;
  }
}
