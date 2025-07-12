

import 'package:social_media_app/features/post/data/models/post_model/first_layer_comment.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';

class PostModel {
  final String id;
  final String topic;
  final String description;
  final List<String> images;
  final List<String> likes;
  final int likesCount;
  final bool reelFlag;
  final UserModel publisher;
  final List<CommentModel> comments;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.topic,
    required this.description,
    required this.images,
    required this.likes,
    required this.likesCount,
    required this.reelFlag,
    required this.publisher,
    required this.comments,
    required this.createdAt,
  });
  factory PostModel.fromResponse(Map<dynamic, dynamic> json) {
    return PostModel.fromJson(json['post']);
  }
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      topic: json['topic'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['files']),
      likes: List<String>.from(json['likes']),
      likesCount: (json['likes'] as List).length,
      reelFlag: json['reelFlag'] ?? false,
      publisher: UserModel.fromJson(json['publisher']),
      comments: (json['firstLayerComments'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Post toEntity() {
    return Post(
      id: id,
      topic: topic,
      description: description,
      images: images,
      isLiked: false,
      likes:likes,
      likesCount: likesCount,
      reelFlag: reelFlag,
      publisher: publisher.toEntity(),
      comments: comments.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}
