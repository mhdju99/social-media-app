import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/realtime/domain/entities/chat_entity.dart';
import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';

class GetAllChatUsecase  {
  final RealtimeRepository repository;

  GetAllChatUsecase(this.repository);

Future<Either<Failure, List<ChatEntity>>> call() {
    return repository.getAllChats();
  }
}
