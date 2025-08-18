// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:social_media_app/features/post/data/models/post_model/first_layer_comment.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';

class PostDetailsModel {
  final String id;
  final String topic;
  final String description;
  final List<String> images;
  final List<String> likes;
  final int likesCount;
  final bool reelFlag;
    final bool hiddenFlag;

  final UserModel publisher;
  final List<CommentModel> comments;
  final DateTime createdAt;

  PostDetailsModel({
    required this.id,
    required this.topic,
    required this.description,
    required this.images,
    required this.likes,
    required this.likesCount,
    required this.reelFlag,
    required this.hiddenFlag,
    required this.publisher,
    required this.comments,
    required this.createdAt,
  });
  factory PostDetailsModel.fromResponse(Map<dynamic, dynamic> json) {
    return PostDetailsModel.fromJson(json['post']);
  }
  factory PostDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    return PostDetailsModel(
      id: json['_id'],
      topic: json['topic'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['files']),
      likes: List<String>.from(json['likes']),
      likesCount: (json['likes'] as List).length,
      reelFlag: json['reelFlag'] ?? false,
      hiddenFlag: json['hiddenFlag'] ?? false,
      publisher:json['publisher'] is Map<String, dynamic>? UserModel.fromJson(json['publisher']):UserModel(id: "", userName: "", profileImage: ""),
      comments: (json['firstLayerComments'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  PostDetails toEntity() {
    return PostDetails(
      hiddenFlag: hiddenFlag,
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

  @override
  String toString() {
    return 'PostModel(id: $id, topic: $topic, description: $description, images: $images, likes: $likes, likesCount: $likesCount, reelFlag: $reelFlag, publisher: $publisher, comments: $comments, createdAt: $createdAt)';
  }
}
