import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';

/// PostRepository is an abstract class defining the contract for operations
/// related to data within the domain layer.
/// Concrete implementations of this repository interface will be provided
/// in the data layer to interact with specific data sources (e.g., API, database).
abstract class PostRepository {
  Future<Either<Failure, void>> createPost({
    required String topic,
    required bool reelFlag,
    required String describtion,
    required List<File> images,
  });
  Future<Either<Failure, void>> modifyPost({
    required String postId,
    required String topic,
    required String describtion,
    required List<File>? images,
    List<String>? deleteImagesIds,
  });
  Future<Either<Failure, void>> deletePost({required String postId});
    Future<Either<Failure, Post>> getPostDetails({required String postId});

  Future<Either<Failure, void>> likeUnlikePost({required String postId});
  Future<Either<Failure, void>> addComment({
    required String postId,
    required String content,
  });
}
