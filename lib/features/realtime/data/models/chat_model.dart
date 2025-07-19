import '../../domain/entities/chat_entity.dart';

class ChatModel {
  final String id;
  final List<String> users;
  final List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.users,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      users: List<String>.from(json['users'].map((u) => u.toString())),
      messages: (json['messages'] as List)
          .map((msg) => MessageModel.fromJson(msg))
          .toList(),
    );
  }

  /// 🔁 تحويل ChatModel إلى ChatEntity
  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      users: users,
      messages: messages.map((msg) => msg.toEntity()).toList(),
    );
  }
}

class MessageModel {
  final String from;
  final String to;
  final String content;
  final DateTime createdAt;

  MessageModel({
    required this.from,
    required this.to,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      from: json['owner'].toString(),
      to: json['to'].toString(),
      content: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// 🔁 تحويل MessageModel إلى MessageEntity
  MessageEntity toEntity() {
    return MessageEntity(
      from: from,
      to: to,
      content: content,
      createdAt: createdAt,
    );
  }
}
