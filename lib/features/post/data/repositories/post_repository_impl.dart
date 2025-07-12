import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/post/data/data_sources/Post_Remot_DataSource.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemotDataSource postRemotDataSource;
  PostRepositoryImpl(this.postRemotDataSource);

  @override
  Future<Either<Failure, void>> addComment(
      {required String postId, required String content}) async {
    try {
      await postRemotDataSource.addComment(postId: postId, content: content);
      // await local.saveToken(user.)
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: "somthing wrong"));
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
      return left(Failure(errMessage: "somthing wrong"));
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
      return left(Failure(errMessage: "somthing wrong"));
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
      return left(Failure(errMessage: "somthing wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> modifyPost({
    required String postId,
    required String topic,
    required String describtion,
    List<File>? images,
    List<String>? deleteImagesIds,
  }) async {
    try {
      await postRemotDataSource.modifyPost(
        postId: postId,
          topic: topic, describtion: describtion, images: images);
      // await local.saveToken(user.)
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: "somthing wrong"));
    }
  }

  @override
  Future<Either<Failure, Post>> getPostDetails({required String postId}) async {
    try {
    final postModel =  await postRemotDataSource.getPostDetails(postId: postId);
      return right(postModel.toEntity());
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: "somthing wrong"));
    }
  }
}
