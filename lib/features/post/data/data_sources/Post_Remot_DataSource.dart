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

import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/post/data/models/post_model/first_layer_comment.dart';
import 'package:social_media_app/features/post/data/models/post_model/postDetailsModel.dart';
import 'package:social_media_app/features/post/data/models/post_model/post_model.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';

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
          required bool hiddenFlag,

  });
    Future<void> updatePoststate({
    required String postid,
 

  });
  Future<void> modifyPost(
      {required String postId,
      required String describtion,
      List<File>? images,
      List<String>? deleteImagesIds});
  Future<void> deletePost({required String postId});
  Future<PostDetailsModel> getPostDetails({required String postId});
  Future<List<PostModel>> getPosts({
    required bool isRells,
    List<String>? existingPostIds,
    List<String>? topic,
    Map<String, dynamic>? logs,
    String? gender,
    int? min,
    int? max,
  });
  Future<void> likeUnlikePost({required String postId});
  Future<Map<String, dynamic>> addComment({
    required String postId,
    required String content,
    bool? hiddenflag,
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
  Future<Map<String, dynamic>> addComment(
      {required String postId,
      String? repliedTo,
      bool? hiddenflag,
      required String content}) async {
    final Map<String, dynamic> data = {
      "postId": postId,
      "content": content,
    };

    if (repliedTo != null) data['repliedTo'] = repliedTo;
    if (hiddenflag != null) {
      data['hiddenFlag'] = hiddenflag;
    } else {
      data['hiddenFlag'] = false;
    }
    print("hiddenflags ${data}");

    Response response =
        await api.post(await EndPoints.addCommentEndPoint, data: data);
    Map<String, dynamic> resposneData = response.data;
    // CommentModel commentMOdel = CommentModel.fromJson(resposneData['comment']);
    UserModel userMOdel = UserModel.fromJson(resposneData['user']);

    return {"comment": resposneData["comment"]['_id'], "user": userMOdel};
  }

  @override
  Future<void> createPost(
      {required String topic,
      required bool reelFlag,
      required bool hiddenFlag,
      required String describtion,
      required List<File> images}) async {
    final formData = FormData.fromMap({
      'topic': topic,
      'description': describtion,
      'reelFlag': reelFlag.toString(),
      'hiddenFlag': hiddenFlag.toString(),
    });
    for (var image in images) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(image.path,
              contentType: reelFlag
                  ? MediaType('video', 'mp4')
                  : MediaType('image', 'jpeg'),
              filename: image.path.split('/').last),
        ),
      );
    }
    await api.post(
      await EndPoints.createPostEndPoint,
      data: formData,
    );
  }

  @override
  Future<void> deletePost({required String postId}) async {
    await api.delete(await EndPoints.deletePostEndPoint,
        queryParameters: {"postId": postId});
  }

  @override
  Future<void> likeUnlikePost({required String postId}) async {
    await api
        .put(await EndPoints.likeUnlikePostEndPoint, data: {"postId": postId});
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
    await api
        .patch(await EndPoints.updatePostEndPoint, data: formData, header: {
      "post-id": postId.toString(),
    });
  }

  @override
  Future<PostDetailsModel> getPostDetails({required String postId}) async {
    Response response = await api.get(await EndPoints.getPostEndPoint,
        queryParameters: {"postId": postId});

    Map<String, dynamic> resposneData = response.data;
        print("}}}${resposneData}");

    PostDetailsModel postModel = PostDetailsModel.fromResponse(resposneData);
    print("}}}${postModel.comments.toString()}");
    debugPrint("❤💞");
    return postModel;
  }

  @override
  Future<void> likeUnlikeComment({required String commentId}) async {
    debugPrint("❤");
    debugPrint(commentId);
    await api.put(
      await EndPoints.likeCommentEndPoint,
      data: {"commentId": commentId},
    );
  }

  @override
  Future<void> deleteComment({required String commentId}) async {
    final x = await api.delete(
      await EndPoints.deleteCommentEndPoint,
      queryParameters: {"commentId": commentId},
    );
  }

  @override
  Future<List<CommentModel>> getReplies(
      {required List<String> commentIds}) async {
    final response = await api.get(
      await EndPoints.getRepliesEndPoint,
      queryParameters: {"commentsIds": commentIds.join(',')},
    );

    final data = response.data['replies'] as List;
    return data.map((json) => CommentModel.fromJson(json)).toList();
  }

  @override
  Future<List<PostModel>> getPosts({
    required bool isRells,
    List<String>? existingPostIds,
    List<String>? topic,
    Map<String, dynamic>? logs,
    String? gender,
    int? min,
    int? max,
  }) async {
    final Map<String, dynamic> datamap = {};

    if (isRells != null) datamap['reelFlag'] = isRells;
    if (existingPostIds != null) datamap['existingPostIds'] = existingPostIds;

    if (topic != null) datamap['categories'] = topic;
    if (logs != null) datamap['logs'] = logs;
    if (gender != null) datamap['gender'] = gender;
    if (min != null) datamap['min'] = min;
    if (max != null) datamap['max'] = max;
    datamap['postsNumber'] = 3;

    final response = await api.post(
      await EndPoints.getPostsEndPoint,
      data: datamap,
    );

    final data = response.data as List;
    return data.map((json) => PostModel.fromJson(json)).toList();
  }
  
  @override
  Future<void> updatePoststate({required String postid})async {

    await api.put(
      await EndPoints.updatehiddenstatusEndPoint,
      queryParameters: {"postId": postid},
    );
  }
}
