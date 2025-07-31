import 'package:dartz/dartz.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import '../../../../core/errors/failure.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  Future<Either<Failure, List<Post>>> call({
    required bool isRells,
    List<String>? existingPostIds,
    List<String>? topic,

    Map<String, dynamic>? logs,
    String? gender,
    int? maxAge,
    int? minAge,
    List<String>? categories,
  }) {
        print("🈹$topic");


    return repository.getPosts(isRells: isRells,
    topic: topic,
    existingPostIds: existingPostIds,
    
    gender: gender,
    logs: logs,
    maxAge: maxAge,
    minAge: minAge);
  }
}
