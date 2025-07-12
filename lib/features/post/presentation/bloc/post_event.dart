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

class ModifyPostRequested extends PostEvent {
  final String postId;
  final String newTopic;
  final String newDescription;
  final List<File>? newImages;
  final List<String> imagesToDelete;

  const ModifyPostRequested({
    required this.postId,
    required this.newTopic,
    required this.newDescription,
    this.newImages,
    this.imagesToDelete = const [],
  });

  @override
  List<Object?> get props =>
      [postId, newTopic, newDescription, newImages, imagesToDelete];
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
  final String postId;

  const AddCommentsRequested(this.comments, this.postId);

  @override
  List<Object?> get props => [comments, postId];
}
