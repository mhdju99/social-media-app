// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';

import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';
import 'package:social_media_app/features/post/domian/usecases/add_comment.dart';
import 'package:social_media_app/features/post/domian/usecases/create_post.dart';
import 'package:social_media_app/features/post/domian/usecases/get_post_details.dart';
import 'package:social_media_app/features/post/domian/usecases/like_unlike_post.dart';
import 'package:test/test.dart';

part 'post_state.dart';
part 'post_event.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  GetPostDetails getPostDetails;
  LikeUnlikePost likeUnlikePost;
  GetUserIdUseCase getUserIdUseCase;
  AddComment addComment;
  CreatePost createPost;
  PostBloc({
    required this.getPostDetails,
    required this.getUserIdUseCase,
    required this.likeUnlikePost,
    required this.addComment,
    required this.createPost,
  }) : super(PostInitial()) {
    // on<CreatePostRequested>(_handleCreatePost);
    // on<ModifyPostRequested>((ModifyPostRequested event, emit) async {
    //   final result = await postRepository.modifyPost(
    //       postId: event.postId,
    //       topic: event.newTopic,
    //       describtion: event.newDescription,
    //       images: event.newImages,
    //       deleteImagesIds: event.imagesToDelete);
    //   result.fold(
    //     (l) {
    //       emit(PostError(l.errMessage));
    //     },
    //     (_) => emit(PostCreated()),
    //   );
    // });
    on<GetPostRequested>((GetPostRequested event, emit) async {
      emit(PostLoading());
      final userId = await getUserIdUseCase();
      final result = await getPostDetails(event.postId);

      result.fold(
        (l) {
          emit(PostError(l.errMessage));
        },
        (post) {
          final isLiked = post.likes.contains(userId);
          final updatedPosts = post.copyWith(isLiked: isLiked);
          emit(PostdetailsLoaded(updatedPosts));
        },
      );
    });
    on<CreatePostRequested>((CreatePostRequested event, emit) async {
      emit(PostLoading());

      final result = await createPost(
          topic: event.topic,
          describtion: event.description,
          images: event.images,
          reelFlag: event.reelFlag);
      result.fold(
        (l) {
          emit(PostError(l.errMessage));
        },
        (_) {
          print("sssss");

          emit(PostCreated());
        },
      );
    });
    on<ToggleLikePostRequested>((ToggleLikePostRequested event, emit) async {
      if (state is PostdetailsLoaded) {
        final currentState = state as PostdetailsLoaded;
        final post = currentState.post;
        final updatedPost = post.copyWith(
            isLiked: !post.isLiked,
            likesCount:
                post.isLiked ? post.likesCount - 1 : post.likesCount + 1);
        emit(currentState.copyWith(post: updatedPost));

        final result = await likeUnlikePost(event.postId);
        result.fold(
          (l) {
            final revertedPost = post;
            emit(LikeCommentFalier(l.errMessage));

            emit(currentState.copyWith(post: revertedPost));
            // final current = state as PostdetailsLoaded;

            // emit(currentState.copyWith(errorMessage: "حدث خطأ أثناء الإعجاب"));
            // emit(currentState.copyWith(errorMessage: null));
          },
          (_) {},
        );
      }
    });
    on<AddCommentsRequested>((AddCommentsRequested event, emit) async {
      if (state is PostdetailsLoaded) {
        final currentState = state as PostdetailsLoaded;
        final post = currentState.post;

        final result =
            await addComment(content: event.comments, postId: event.postId);
        result.fold(
          (l) {
            emit(LikeCommentFalier(l.errMessage));
            emit(currentState);

            // emit(currentState.copyWith(errorMessage: "حدث خطأ أثناء الإعجاب"));
            // emit(currentState.copyWith(errorMessage: null));
          },
          (_) {
            final updatedComments = List<Comment>.from(post.comments)
              ..add(Comment(
                  id: "",
                  content: event.comments,
                  user: User(id: "", userName: "hhhhhmod0", profileImage: ""),
                  repliedBy: [],
                  likedBy: [],
                  createdAt: DateTime.now()));

            final updatedPost = post.copyWith(comments: updatedComments);
            emit(currentState.copyWith(post: updatedPost));
          },
        );
      }
    });
  }

  // FutureOr<void> _handleCreatePost(CreatePostRequested event, emit) async {
  //   final result = await postRepository.createPost(
  //     topic: event.topic,
  //     reelFlag: event.reelFlag,
  //     describtion: event.description,
  //     images: event.images,
  //   );
  //   result.fold(
  //     (l) {
  //       emit(PostError(l.errMessage));
  //     },
  //     (_) => emit(PostCreated()),
  //   );
  // }
}
