import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectToSocketEvent extends ChatEvent {
  final String token;

  ConnectToSocketEvent(this.token);

  @override
  List<Object?> get props => [token];
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
class GetChatEvent extends ChatEvent {
  final String targetUserId;
  GetChatEvent(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}
