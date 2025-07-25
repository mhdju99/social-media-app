import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/post/data/data_sources/Post_Remot_DataSource.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemotDataSource postRemotDataSource;
  PostRepositoryImpl(this.postRemotDataSource);

  @override
  Future<Either<Failure, void>> addComment({
    required String postId,
    required String content,
    String? repliedTo,
  }) async {
    try {
      await postRemotDataSource.addComment(
        postId: postId,
        content: content,
        repliedTo: repliedTo,
      );
      // await local.saveToken(user.)
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likeUnlikeComment(
      {required String commentId}) async {
    try {
      await postRemotDataSource.likeUnlikeComment(commentId: commentId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(
      {required String commentId}) async {
    try {
      await postRemotDataSource.deleteComment(commentId: commentId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getReplies(
      {required List<String> commentIds}) async {
    try {
      final replyModels =
          await postRemotDataSource.getReplies(commentIds: commentIds);
      final replies = replyModels.map((model) => model.toEntity()).toList();
      return right(replies);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPost(
      {required String topic,
      required bool reelFlag,
      required String describtion,
      required List<File> images}) async {
    try {
      await postRemotDataSource.createPost(
          topic: topic,
          reelFlag: reelFlag,
          describtion: describtion,
          images: images);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost({required String postId}) async {
    try {
      await postRemotDataSource.deletePost(postId: postId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likeUnlikePost({required String postId}) async {
    try {
      await postRemotDataSource.likeUnlikePost(postId: postId);
      // await local.saveToken(user.)
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> modifyPost({
    required String postId,
    required String describtion,
    List<File>? images,
    List<String>? deleteImagesIds,
  }) async {
    try {
      await postRemotDataSource.modifyPost(
          postId: postId,
          describtion: describtion,
          images: images,
          deleteImagesIds: deleteImagesIds);
      // await local.saveToken(user.)
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, PostDetails>> getPostDetails(
      {required String postId}) async {
    try {
      final postModel =
          await postRemotDataSource.getPostDetails(postId: postId);
      return right(postModel.toEntity());
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts({required bool isRells}) async {
    try {
      final PostModels = await postRemotDataSource.getPosts(isRells: isRells);
      final posts = PostModels.map((model) => model.toEntity()).toList();
      return right(posts);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }
}
