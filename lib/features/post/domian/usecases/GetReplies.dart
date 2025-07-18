import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';
import '../entities/comment_entity.dart'; // تأكد من وجود هذا المسار

class GetReplies {
  final PostRepository repository;

  GetReplies(this.repository);

  Future<Either<Failure, List<Comment>>> call(List<String> commentIds) {
    return repository.getReplies(commentIds: commentIds);
  }
}
