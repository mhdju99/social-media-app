import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

/// use case is a class responsible for encapsulating a specific piece of business logic or
/// a particular operation that your application needs to perform.
/// It acts as a bridge between the presentation
/// layer and the data layer.
class LogOutUserUseCase {
  final AuthenticationRepository authenticationRepository;
  LogOutUserUseCase(this.authenticationRepository);

 Future<void> call(){
    return authenticationRepository.logOut();
  }
}
