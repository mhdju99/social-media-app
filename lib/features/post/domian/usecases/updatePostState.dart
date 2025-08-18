import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';

class Updatepoststate {
  final PostRepository repository;

  Updatepoststate(this.repository);

  Future<Either<Failure, void>> call(String postid) {
    return repository.updatePoststate(postid: postid);
  }
}
