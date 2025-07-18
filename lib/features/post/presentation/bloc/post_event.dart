// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object?> get props => [];
}

class GetPostRequested extends PostEvent {
  final String postId;

  const GetPostRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}
class GetPostsRequested extends PostEvent {
  final bool isRells;

  const GetPostsRequested({
  required  this.isRells});

  @override
  List<Object?> get props => [isRells];
}
class CreatePostRequested extends PostEvent {
  final String topic;
  final String description;
  final List<File> images;
  final bool reelFlag;

  const CreatePostRequested({
    required this.topic,
    required this.description,
    required this.images,
    required this.reelFlag,
  });

  @override
  List<Object?> get props => [topic, description, images, reelFlag];
}
class DeleteCommentEvent extends PostEvent {
  final String commentId;

  const DeleteCommentEvent({required this.commentId});
}

class LikeCommentEvent extends PostEvent {
  final String commentId;

  const LikeCommentEvent({required this.commentId});
}

class GetRepliesEvent extends PostEvent {
  final List<String> commentsIds;

  const GetRepliesEvent({required this.commentsIds});
}

class ModifyPostRequested extends PostEvent {
  final String postId;
  final String newDescription;
  final List<File>? newImages;
 final  List<String>? imagesToDelete;

  const ModifyPostRequested({
    required this.postId,
    required this.newDescription,
    this.newImages,
    this.imagesToDelete,
  });

  @override
  List<Object?> get props =>
      [postId, newDescription, newImages, imagesToDelete];
}

class DeletePostRequested extends PostEvent {
  final String postId;

  const DeletePostRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ToggleLikePostRequested extends PostEvent {
  final String postId;

  const ToggleLikePostRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}
class PostErrorOccurred extends PostEvent {
  final String message;
  const PostErrorOccurred(this.message);
}
class AddCommentsRequested extends PostEvent {
  final String comments;
  final String? replyto;
  final String postId;

  const AddCommentsRequested(this.comments, this.postId,
  this.replyto);

  @override
  List<Object?> get props => [comments, postId,replyto];
}
