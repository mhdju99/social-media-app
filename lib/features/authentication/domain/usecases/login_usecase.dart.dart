import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

/// use case is a class responsible for encapsulating a specific piece of business logic or
/// a particular operation that your application needs to perform.
/// It acts as a bridge between the presentation
/// layer and the data layer.
class LoginUserUseCase {
  final AuthenticationRepository authenticationRepository;
  LoginUserUseCase(this.authenticationRepository);

 Future<Either<Failure, UserEntity>> call(LoginParams params){
    return authenticationRepository.logIn(email: params.email,password: params.password);
  }
}
