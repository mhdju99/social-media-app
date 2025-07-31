import 'package:dartz/dartz.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';
import '../../../../core/errors/failure.dart';

class AddComment {
  final PostRepository repository;

  AddComment(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String postId,
    required String content,
      String? repliedTo,

  }) {
    return repository.addComment(postId: postId, content: content,
    repliedTo: repliedTo,
);
  }
}
