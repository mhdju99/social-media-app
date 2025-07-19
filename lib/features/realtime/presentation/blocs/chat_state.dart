import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/realtime/domain/entities/chat_entity.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConnected extends ChatState {}

class ChatMessageReceived extends ChatState {
  final Map<String, dynamic> message;

  ChatMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final ChatEntity chat;
  ChatLoaded(this.chat);

  @override
  List<Object> get props => [chat];
}
class UserOnlineStatusLoaded extends ChatState {
  final bool isOnline;
  UserOnlineStatusLoaded(this.isOnline);

  @override
  List<Object> get props => [isOnline];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);

  @override
  List<Object> get props => [message];
}
