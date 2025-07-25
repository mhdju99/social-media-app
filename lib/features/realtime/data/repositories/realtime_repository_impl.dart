import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/realtime/data/models/chat_model.dart';
import 'package:social_media_app/features/realtime/domain/entities/chat_entity.dart';
import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';
import 'package:social_media_app/features/realtime/data/data_sources/realtime_data_source.dart';

class RealtimeRepositoryImpl implements RealtimeRepository {
  final RealtimeDataSource dataSource;
  RealtimeRepositoryImpl(this.dataSource);

  @override
  Future<void> connect(String token) async {
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

  // ✅ الجدد:
  @override
  Stream<String> get userOnline => dataSource.userOnline;

  @override
  Stream<Map<String, dynamic>> get userOffline => dataSource.userOffline;

  @override
  Future<Either<Failure, Map<String,dynamic> >> isUserOnline(String targetUserId) async {
    try {
      final Map<String,dynamic>  isOnline = await dataSource.isUserOnline(targetUserId);
      return right(isOnline);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (e) {
      return left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChat(String targetUserId) async {
    try {
      final ChatModel chatModel = await dataSource.getChat(targetUserId);
      return right(chatModel.toEntity());
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (e) {
      return left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getAllChats() async {
    try {
      final List<ChatModel> models = await dataSource.getAllChats();
      final entities = models.map((e) => e.toEntity()).toList();
      return right(entities);
    } on ServerException catch (e) {
      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (e) {
      return left(Failure(errMessage: e.toString()));
    }
  }
}
