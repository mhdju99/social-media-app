import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';


class GetUserIdUseCase {
  final AuthenticationRepository repository;

  GetUserIdUseCase(this.repository);

Future<String?>  call() {

    
    return repository.fetchCachedUserId();
  }
}
