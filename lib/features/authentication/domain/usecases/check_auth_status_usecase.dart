import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';

class CheckAuthStatusUseCase {
  final AuthenticationRepository repository;

  CheckAuthStatusUseCase(this.repository);

   Future<Map<String, dynamic>> call() {
    return repository.isUserLogIn();
  }
}
