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
import 'package:social_media_app/features/post/data/models/post_model/first_layer_comment.dart';
import 'package:social_media_app/features/post/data/models/post_model/postDetailsModel.dart';
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
  Future<void> modifyPost(
      {required String postId,
      required String describtion,
      List<File>? images,
      List<String>? deleteImagesIds});
  Future<void> deletePost({required String postId});
  Future<PostDetailsModel> getPostDetails({required String postId});
   Future<List<PostModel>>  getPosts({required bool isRells});
  Future<void> likeUnlikePost({required String postId});
  Future<void> addComment({
    required String postId,
    required String content,
    String? repliedTo,
  });
  Future<void> likeUnlikeComment({required String commentId});
  Future<void> deleteComment({required String commentId});
  Future<List<CommentModel>> getReplies({required List<String> commentIds});
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
      {required String postId,
      String? repliedTo,
      required String content}) async {
    final Map<String, dynamic> data = {
      "postId": postId,
      "content": content,
    };

    if (repliedTo != null) data['repliedTo'] = repliedTo;

    await api.post(EndPoints.addcommentEndPoint, data: data);
  }

  @override
  Future<void> createPost(
      {required String topic,
      required bool reelFlag,
      required String describtion,
      required List<File> images}) async {
    final formData = FormData.fromMap({
      'topic': topic,
      'description': describtion,
      'reelFlag': reelFlag.toString(),
    });
    for (var image in images) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(image.path,
              contentType:reelFlag? MediaType('video', 'mp4')
                  :MediaType('image', 'jpeg'),
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
      {required String postId,
      required String describtion,
      List<File>? images,
      List<String>? deleteImagesIds}) async {
final formData = FormData.fromMap({
      'description': describtion,
      if (deleteImagesIds != null && deleteImagesIds.isNotEmpty)
        'deleteImagesIds': deleteImagesIds.join('-'),
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
    await api.patch(EndPoints.updatepostEndPoint, data: formData, header: {
      "post-id": postId.toString(),
    });
  }

  @override
  Future<PostDetailsModel> getPostDetails({required String postId}) async {
    Response response = await api
        .get(EndPoints.getpostEndPoint, queryParameters: {"postId": postId});

    Map<String, dynamic> resposneData = response.data;
    PostDetailsModel postModel = PostDetailsModel.fromResponse(resposneData);
    debugPrint("❤💞");
    debugPrint(postModel.comments.toString());
    return postModel;
  }

  @override
  Future<void> likeUnlikeComment({required String commentId}) async {
    debugPrint("❤");
    debugPrint(commentId);
    await api.put(
      EndPoints.likeCommentEndPoint,
      data: {"commentId": commentId},
    );
  }

  @override
  Future<void> deleteComment({required String commentId}) async {
    final x = await api.delete(
      EndPoints.deleteCommentEndPoint,
      queryParameters: {"commentId": commentId},
    );
 
  }

  @override
  Future<List<CommentModel>> getReplies(
      {required List<String> commentIds}) async {
    final response = await api.get(
      EndPoints.getRepliesEndPoint,
      queryParameters: {"commentsIds": commentIds.join(',')},
    );

    final data = response.data['replies'] as List;
    return data.map((json) => CommentModel.fromJson(json)).toList();
  }
  
  @override
  Future<List<PostModel>> getPosts({required bool isRells}) async {
    final response = await api.post(
      EndPoints.getpostsEndPoint,
      data: {"reelFlag":isRells},
    );

    final data = response.data['posts'] as List;
    return data.map((json) => PostModel.fromJson(json)).toList();
  }
}
