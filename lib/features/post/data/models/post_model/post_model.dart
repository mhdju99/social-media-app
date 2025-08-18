// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:social_media_app/features/post/data/models/post_model/first_layer_comment.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';

class PostModel {
  final String id;
  final String topic;
  final String description;
  final List<String> images;
  final List<String> likes;
  final int likesCount;
  final bool reelFlag;
  final bool hiddenFlag;
  final UserModel publisher;
  final List<String> comments;
  final DateTime createdAt; 

  PostModel({
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
  factory PostModel.fromResponse(Map<dynamic, dynamic> json) {
    return PostModel.fromJson(json['post']);
  }
  factory PostModel.fromJson(Map<dynamic, dynamic> json) {
    return PostModel(
      id: json['_id'],
      topic: json['topic'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['files']),
      likes: List<String>.from(json['likes']),
      likesCount: (json['likes'] as List).length,
      reelFlag: json['reelFlag'] ?? false,
      hiddenFlag: json['hiddenFlag'] ?? false,
      publisher:json['publisher'] is Map<String, dynamic>? UserModel.fromJson(json['publisher']):UserModel(id: "", userName: "", profileImage: ""),
      comments:(json['firstLayerComments'] != null &&
           json['firstLayerComments'] is List &&
           (json['firstLayerComments'] as List).isNotEmpty &&
           (json['firstLayerComments'] as List).every((e) => e is String))
    ? List<String>.from(json['firstLayerComments'])
    : [],
      
      
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Post toEntity() {
    return Post(
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
      comments: comments,
      createdAt: createdAt,
    );
  }

  @override
  String toString() {
    return 'PostModel(id: $id, topic: $topic, description: $description, images: $images, likes: $likes, likesCount: $likesCount, reelFlag: $reelFlag, publisher: $publisher, comments: $comments, createdAt: $createdAt)';
  }
}
