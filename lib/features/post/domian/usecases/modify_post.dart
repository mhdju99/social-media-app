import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';

class ModifyPost {
  final PostRepository repository;

  ModifyPost(this.repository);

  Future<Either<Failure, void>> call({
    required String postId,
    required String describtion,
    List<File>? images,
    List<String>? deleteImagesIds,
  }) {
    return repository.modifyPost(
      postId: postId,
      describtion: describtion,
      images: images,
      deleteImagesIds: deleteImagesIds,
    );
  }
}
