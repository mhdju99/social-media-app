part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostdetailsLoaded extends PostState {
  final PostDetails post;
    final String? errorMessage; // ✅ جديد

  PostdetailsLoaded(this.post, {this.errorMessage});
    List<Object?> get props => [post,errorMessage];

    PostdetailsLoaded copyWith({PostDetails? post,String? errorMessage}) {
    return PostdetailsLoaded(
      post ?? this.post,
     errorMessage:  errorMessage ?? this.errorMessage,
    );
  }

}

final class PostCreated extends PostState {}
final class delDone extends PostState {}

final class PostModified extends PostState {}

final class PostDeleted extends PostState {}
class CommentLoading extends PostState {}


class CommentFailure extends PostState {
  final String error;

  const CommentFailure(this.error);
}

class RepliesLoaded extends PostState {
  final List<Comment>? replies;

  const RepliesLoaded(this.replies);
   RepliesLoaded copyWith({List<Comment>? replies}) {
    return RepliesLoaded(
      replies ??this.replies

    );
  }
    @override
  List<Object?> get props => [replies];
}

class PostsLoaded extends PostState {
  final List<Post> posts;

  const PostsLoaded(this.posts);
  PostsLoaded copyWith({List<Post>? posts}) {
    return PostsLoaded(posts ?? this.posts);
  }

  @override
  List<Object> get props => [PostDetails];
}
final class PostLikeToggled extends PostState {}

class PostError extends PostState {
  final String message;
  const PostError(this.message);
  @override
  List<Object> get props => [message];
}
class LikeCommentFalier extends PostState {
  final String message;
  const LikeCommentFalier(this.message);
  @override
  List<Object> get props => [message];
}

