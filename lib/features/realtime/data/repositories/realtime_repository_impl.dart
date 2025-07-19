import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/realtime/data/models/chat_model.dart';
import 'package:social_media_app/features/realtime/domain/entities/chat_entity.dart';
import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';
import 'package:social_media_app/features/realtime/data/data_sources/realtime_data_source.dart';

/// RealtimeRepositoryImpl is the concrete implementation of the RealtimeRepository
/// interface.
/// This class implements the methods defined in RealtimeRepository to interact
/// with data. It acts as a bridge between the domain layer
/// (use cases) and the data layer (data sources).
class RealtimeRepositoryImpl implements RealtimeRepository {
  final RealtimeDataSource dataSource;
  RealtimeRepositoryImpl(this.dataSource);
  @override
  Future<void> connect(String token) async {
        print("sSSSSSSSS");

    await dataSource.connect(token);
  }

  @override
  Future<void> sendMessage(String to, String content) async {
    dataSource.sendMessage(to, content);
  }

  @override
  Stream<List<dynamic>> get initialNotifications =>
      dataSource.initialNotifications;

  @override
  Stream<Map<String, dynamic>> get newNotification =>
      dataSource.newNotification;
  @override
  void disconnect() {
    dataSource.disconnect();
  }

  @override
  Stream<Map<String, dynamic>> get messageStream => dataSource.messageStream;

  @override
  Future<Either<Failure, bool>> isUserOnline(String targetUserId) async {
    try {
      final bool isUserOnline = await dataSource.isUserOnline(targetUserId);
      return right(isUserOnline);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChat(String targetUserId) async {
    try {
      final ChatModel chatModel = await dataSource.getChat(targetUserId);
   final   chats = chatModel.toEntity();
      return right(chats);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
      return left(Failure(errMessage: a.toString()));
    }
  }
  
  

}
