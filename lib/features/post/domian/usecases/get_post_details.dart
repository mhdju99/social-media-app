import 'package:dartz/dartz.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import '../../../../core/errors/failure.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';

class GetPostDetails {
  final PostRepository repository;

  GetPostDetails(this.repository);

  Future<Either<Failure, PostDetails>> call(String postId) {
    return repository.getPostDetails(postId: postId);
  }
}
