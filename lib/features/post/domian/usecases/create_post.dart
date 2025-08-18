import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost(this.repository);

  Future<Either<Failure, void>> call({
    required String topic,
    required bool reelFlag,
    required String describtion,
    required List<File> images,
                required bool hiddenFlag,

  }) {
    return repository.createPost(
      topic: topic,
                hiddenFlag: hiddenFlag,

      reelFlag: reelFlag,
      describtion: describtion,
      images: images,
    );
  }
}
