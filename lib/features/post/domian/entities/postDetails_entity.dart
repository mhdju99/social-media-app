import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'user_entity.dart';

class PostDetails extends Equatable {
  final String id;
  final String topic;
  final String description;
  final List<String> images;
  final List<String> likes;
 final  bool isLiked;
 final  bool? isMyPost;
  final int likesCount;
  final bool reelFlag;
  final User publisher;
  final List<Comment> comments;
  final DateTime createdAt;

  const PostDetails({
    required this.id,
    required this.topic,
    required this.description,
    required this.images,
    required this.likes,
    required this.isLiked,
    required this.likesCount,
    required this.reelFlag,
    required this.publisher,
    required this.comments,
    required this.createdAt,
    this.isMyPost
  });

  @override
  List<Object?> get props => [
        id,
        topic,
        description,
        images,
        isLiked,
        likesCount,
        reelFlag,
        publisher,
        comments,
        likes,
        isMyPost
      ];
      PostDetails copyWith({
    String? id,
    String? topic,
    String? description,
    List<String>? images,
    List<String>? likes,
    bool? isLiked,
    bool? isMyPost,
    int? likesCount,
    bool? reelFlag,
    User? publisher,
    List<Comment>? comments,
    DateTime? createdAt,
  }) {
    return PostDetails(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      reelFlag: reelFlag ?? this.reelFlag,
      publisher: publisher ?? this.publisher,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      isMyPost: isMyPost
    );
  }

}
