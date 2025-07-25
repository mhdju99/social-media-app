// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/features/chat/domain/entities/chat_entity.dart
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final List<String> users;
  final List<MessageEntity> messages;

  const ChatEntity({
    required this.id,
    required this.users,
    required this.messages,
  });

  ChatEntity copyWith({
    String? id,
    List<String>? users,
    List<MessageEntity>? messages,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      users: users ?? this.users,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [id, users, messages];
}

class MessageEntity extends Equatable {
  final String from;
  final String to;
  final String content;
  final DateTime createdAt;

  const MessageEntity({
    required this.from,
    required this.to,
    required this.content,
    required this.createdAt,
  });

  MessageEntity copyWith({
    String? from,
    String? to,
    String? content,
    DateTime? createdAt,
  }) {
    return MessageEntity(
      from: from ?? this.from,
      to: to ?? this.to,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object> get props => [from, to, content, createdAt];

  @override
  bool get stringify => true;
}
