import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';

class LikeUnlikeComment {
  final PostRepository repository;

  LikeUnlikeComment(this.repository);

  Future<Either<Failure, void>> call(String commentId) {
    return repository.likeUnlikeComment(commentId: commentId);
  }
}
