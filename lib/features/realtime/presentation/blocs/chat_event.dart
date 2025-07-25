import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectToSocketEvent extends ChatEvent {
  // final String token;

  // ConnectToSocketEvent(this.token);

  // @override
  // List<Object?> get props => [token];
}

class SendMessageEvent extends ChatEvent {
  final String to;
  final String content;

  SendMessageEvent(this.to, this.content);

  @override
  List<Object?> get props => [to, content];
}

class MessageReceivedEvent extends ChatEvent {
  final Map<String, dynamic> message;

  MessageReceivedEvent(this.message);

  @override
  List<Object?> get props => [message];
}
class GetUserOnlineStatusEvent extends ChatEvent {
  final String targetUserId;
  GetUserOnlineStatusEvent(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}
class UserBecameOnlineEvent extends ChatEvent {
  final String userId;

  UserBecameOnlineEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserBecameOfflineEvent extends ChatEvent {
  final String userId;
  final String lastSeenAt; // أو DateTime حسب ما يرسله السيرفر

  UserBecameOfflineEvent(this.userId, this.lastSeenAt);

  @override
  List<Object> get props => [userId, lastSeenAt];
}


class GetChatEvent extends ChatEvent {
  final String targetUserId;
  GetChatEvent(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}
class GetAllChatEvent extends ChatEvent {
  GetAllChatEvent();

}
