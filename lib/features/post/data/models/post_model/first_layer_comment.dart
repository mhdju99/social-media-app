// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';

class CommentModel {
  final String id;
  final String content;
  final UserModel user;
  final List<String>? repliedBy;
  final String? repliedTo;
  final List<String>? likedBy;
  final DateTime createdAt;
  bool? hiddenFlag;

  CommentModel({
    required this.id,
    required this.content,
    required this.user,
    required this.repliedBy,
    this.repliedTo,
    this.hiddenFlag,
    required this.likedBy,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    print("VBV$json");
    return CommentModel(
      id: json['_id'],
      hiddenFlag: json['hiddenFlag'] ,
      content: json['content'],
      user: UserModel.fromJson(json['user']),
      repliedBy: List<String>.from(json['repliedBy']),
      repliedTo: json['repliedTo'],
      likedBy:
          json['likedBy'] != null ? List<String>.from(json['likedBy']) : [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Comment toEntity() {
    return Comment(
      likesCount: likedBy != null ? likedBy!.length : 0,
      id: id,
      content: content,
      user: user.toEntity(),
      repliedBy: repliedBy ?? [],
      repliedTo: repliedTo,
      likedBy: likedBy ?? [],
      createdAt: createdAt,
      hiddenFlag: hiddenFlag,
    );
  }

  @override
  String toString() {
    return 'CommentModel(hiden : $hiddenFlag,id: $id, content: $content, user: $user, repliedBy: $repliedBy, repliedTo: $repliedTo, likedBy: $likedBy, createdAt: $createdAt)';
  }

  CommentModel copyWith({
    String? id,
    String? content,
    UserModel? user,
    List<String>? repliedBy,
    String? repliedTo,
    List<String>? likedBy,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      user: user ?? this.user,
      repliedBy: repliedBy ?? this.repliedBy,
      repliedTo: repliedTo ?? this.repliedTo,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
