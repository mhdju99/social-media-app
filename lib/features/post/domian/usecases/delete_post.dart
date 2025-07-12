import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';

class DeletePost {
  final PostRepository repository;

  DeletePost(this.repository);

  Future<Either<Failure, void>> call(String postId) {
    return repository.deletePost(postId: postId);
  }
}
