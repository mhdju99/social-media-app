import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';

class DeleteComment {
  final PostRepository repository;

  DeleteComment(this.repository);

  Future<Either<Failure, void>> call(String commentId) {
    return repository.deleteComment(commentId: commentId);
  }
}
