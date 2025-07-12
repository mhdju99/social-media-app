part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostdetailsLoaded extends PostState {
  final Post post;
    final String? errorMessage; // ✅ جديد

  PostdetailsLoaded(this.post, {this.errorMessage});
    List<Object?> get props => [post,errorMessage];

    PostdetailsLoaded copyWith({Post? post,String? errorMessage}) {
    return PostdetailsLoaded(
      post ?? this.post,
     errorMessage:  errorMessage ?? this.errorMessage,
    );
  }

}

final class PostCreated extends PostState {}

final class PostModified extends PostState {}

final class PostDeleted extends PostState {}

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

