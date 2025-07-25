import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/realtime/domain/entities/chat_entity.dart';

/// RealtimeRepository is an abstract class defining the contract for operations
/// related to data within the domain layer.
/// Concrete implementations of this repository interface will be provided
/// in the data layer to interact with specific data sources (e.g., API, database).
abstract class RealtimeRepository {
  Future<void> connect(String token);
  Future<void> sendMessage(String to, String content);
  Stream<Map<String, dynamic>> get messageStream;
  Stream<List<dynamic>> get initialNotifications;
  Stream<Map<String, dynamic>> get newNotification;

  void disconnect(); // ✅ مهم لإغلاق الاتصال

  Future<Either<Failure, Map<String, dynamic> >> isUserOnline(String targetUserId);
  Future<Either<Failure, ChatEntity>> getChat(String targetUserId);
  Future<Either<Failure, List<ChatEntity>>> getAllChats();

  // ✅ الجدد: متابعة الحالة اللحظية للمستخدمين
  Stream<String> get userOnline;
  Stream<Map<String, dynamic>> get userOffline;
}
