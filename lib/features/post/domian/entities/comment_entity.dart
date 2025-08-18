import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';

class Comment extends Equatable {
  final String id;
  final String content;
  final User user;
  final List<String> repliedBy;
  final String? repliedTo;
  final List<String>? likedBy;
  final DateTime createdAt;
   final bool isLiked;
   final bool? hiddenFlag;
   final bool? isMyComment;
     final int likesCount;



  const Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.repliedBy,
    this.repliedTo,
    required this.likedBy,
    required this.createdAt,
    required this.likesCount,
    this.isLiked=false,
    this.hiddenFlag,
    this.isMyComment= false,

  });
@override
  List<Object?> get props => [
        id,
        content,
        user,
        repliedBy,
        repliedTo,
        likedBy,
        createdAt,
        isLiked, // 👈 مفقود سابقًا
        isMyComment, // 👈 مفقود
        likesCount,
        hiddenFlag // 👈 مفقود
      ];

      Comment copyWith({
    String? id,
    String? content,
    User? user,
    List<String>? repliedBy,
    String? repliedTo,
    List<String>? likedBy,
    DateTime? createdAt,
    bool? isLiked,
        bool? isMyComment,
           int? likesCount,
       bool?    hiddenFlag


  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      user: user ?? this.user,
      repliedBy: repliedBy ?? this.repliedBy,
      repliedTo: repliedTo ?? this.repliedTo,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked??false,
      isMyComment: isMyComment??this.isMyComment,
      likesCount: likesCount??this.likesCount,
      hiddenFlag: hiddenFlag??this.hiddenFlag,
    );
  }

}
