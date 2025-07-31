// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:social_media_app/features/post/data/models/post_model/user.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import 'package:social_media_app/features/profile/domain/usecases/GetUserProfileUsecase.dart';
import 'package:test/test.dart';

import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';
import 'package:social_media_app/features/post/domian/usecases/DeleteComment.dart';
import 'package:social_media_app/features/post/domian/usecases/GetReplies.dart';
import 'package:social_media_app/features/post/domian/usecases/LikeUnlikeComment.dart';
import 'package:social_media_app/features/post/domian/usecases/add_comment.dart';
import 'package:social_media_app/features/post/domian/usecases/create_post.dart';
import 'package:social_media_app/features/post/domian/usecases/delete_post.dart';
import 'package:social_media_app/features/post/domian/usecases/get_post_details.dart';
import 'package:social_media_app/features/post/domian/usecases/get_posts.dart';
import 'package:social_media_app/features/post/domian/usecases/like_unlike_post.dart';
import 'package:social_media_app/features/post/domian/usecases/modify_post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  GetPostDetails getPostDetails;
  LikeUnlikePost likeUnlikePost;
  GetUserIdUseCase getUserIdUseCase;
  AddComment addComment;
  CreatePost createPost;
  DeleteComment deleteCommentUseCase;
  LikeUnlikeComment likeUnlikeCommentUseCase;
  GetReplies getRepliesUseCase;
  DeletePost deletePost;
  ModifyPost modifyPost;
  GetPosts getPosts;
  GetUserProfileUsecase getUserProfileUsecase;
  PostBloc({
    required this.getPostDetails,
    required this.getUserProfileUsecase,
    required this.likeUnlikePost,
    required this.getUserIdUseCase,
    required this.addComment,
    required this.createPost,
    required this.deleteCommentUseCase,
    required this.likeUnlikeCommentUseCase,
    required this.getRepliesUseCase,
    required this.deletePost,
    required this.modifyPost,
    required this.getPosts,
  }) : super(PostInitial()) {
    // on<CreatePostRequested>(_handleCreatePost);
    on<ModifyPostRequested>((ModifyPostRequested event, emit) async {
      final result = await modifyPost(
          postId: event.postId,
          describtion: event.newDescription,
          images: event.newImages,
          deleteImagesIds: event.imagesToDelete);
      result.fold(
        (l) {
          emit(PostError(l.errMessage));
        },
        (_) => emit(PostCreated()),
      );
    });
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
          final isMyPost = post.publisher.id == userId;
          final updatedComments = post.comments.map((comment) {
            final isMyComment = comment.user.id == userId;
            final isLikedComment = comment.likedBy!.contains(userId);

            return comment.copyWith(
                isMyComment: isMyComment, isLiked: isLikedComment);
          }).toList();

          final updatedPosts = post.copyWith(
              isLiked: isLiked, isMyPost: isMyPost, comments: updatedComments);
          emit(PostdetailsLoaded(updatedPosts));
        },
      );
    });

    on<GetPostsRequested>((GetPostsRequested event, emit) async {
      emit(PostLoading());
      final userId = await getUserIdUseCase();
      List<String> following = [];

      final me = await getUserProfileUsecase((userId != null) ? userId : "");
      me.fold(
        (l) {
          emit(PostError(l.errMessage));
        },
        (me) {
          following = me.following;
        },
      );
      final result = await getPosts(
          isRells: event.isRells,
          topic: event.categories,
          existingPostIds: event.existingPostIds,
          gender: event.gender,
          logs: event.logs,
          maxAge: event.maxAge,
          minAge: event.minAge);


      result.fold(
        (l) {
          emit(PostError(l.errMessage));
        },
        (posts) {
          final updatedPosts =
              posts.where((post) => post.reelFlag == event.isRells).map((post) {
            final isMyPost = post.publisher.id == userId;
            final isLikedPost = post.likes.contains(userId);
            final isFollowME = following.contains(post.publisher.id);

            return post.copyWith(
                isMyPost: isMyPost,
                isLiked: isLikedPost,
                publisher: post.publisher.copyWith(isfollowMe: isFollowME));
          }).toList();

          emit(PostsLoaded(updatedPosts));
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
          emit(PostCreated());
        },
      );
    });
    on<ToggleLikePostRequested>((event, emit) async {
      if (state is PostdetailsLoaded) {
        final currentState = state as PostdetailsLoaded;
        final post = currentState.post;
        final updatedPost = post.copyWith(
          isLiked: !post.isLiked,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );
        emit(currentState.copyWith(post: updatedPost));

        final result = await likeUnlikePost(event.postId);
        result.fold(
          (l) {
            emit(LikeCommentFalier(l.errMessage));
            emit(currentState); // استرجاع الحالة الأصلية عند الخطأ
          },
          (_) {},
        );
      } else if (state is PostsLoaded) {
        final currentState = state as PostsLoaded;
        final posts = currentState.posts;

        // ابحث عن البوست المطلوب وعدل بياناته
        final updatedPosts = posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              isLiked: !post.isLiked,
              likesCount:
                  post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
            );
          }
          return post;
        }).toList();

        emit(currentState.copyWith(posts: updatedPosts));

        final result = await likeUnlikePost(event.postId);
        result.fold(
          (l) {
            emit(LikeCommentFalier(l.errMessage));
            emit(currentState); // استرجاع الحالة الأصلية عند الخطأ
          },
          (_) {},
        );
      }
    });

    on<DeleteCommentEvent>((event, emit) async {
      final result = await deleteCommentUseCase(event.commentId);

      result.fold(
        (failure) {
          // emit(LikeCommentFalier(failure.errMessage));
          debugPrint("❤ssssss");
          debugPrint(event.commentId);
        },
        (_) {
          if (state is PostdetailsLoaded) {
            final currentState = state as PostdetailsLoaded;
            final post = currentState.post;

            final updatedComments = List<Comment>.from(post.comments)
              ..removeWhere((comment) => comment.id == event.commentId);

            final updatedPost = post.copyWith(comments: updatedComments);
            emit(currentState.copyWith(post: updatedPost));
          } else if (state is RepliesLoaded) {
            final currentState = state as RepliesLoaded;
            final replies = currentState.replies;

            final updatedReplies = List<Comment>.from(replies!)
              ..removeWhere((comment) => comment.id == event.commentId);

            emit(currentState.copyWith(replies: updatedReplies));
          }
        },
      );
    });
    on<DeletePostRequested>((event, emit) async {
      final result = await deletePost(event.postId);

      result.fold(
        (failure) {
          // emit(LikeCommentFalier(failure.errMessage));
          debugPrint("❤ssssss");
          debugPrint(failure.errMessage);
        },
        (_) {
          emit(delDone());
        },
      );
    });
    on<LikeCommentEvent>((event, emit) async {
      final result = await likeUnlikeCommentUseCase(event.commentId);

      result.fold(
        (failure) {
          debugPrint("❤");
          debugPrint("false");
          // emit(CommentFailure(failure.errMessage));
        },
        (_) {
          debugPrint("❤");
          debugPrint("true");
          if (state is PostdetailsLoaded) {
            final currentState = state as PostdetailsLoaded;
            final post = currentState.post;

            final updatedComments = post.comments.map((comment) {
              if (comment.id == event.commentId) {
                final wasLiked = comment.isLiked;
                return comment.copyWith(
                  isLiked: !wasLiked,
                  likesCount: wasLiked
                      ? comment.likesCount - 1
                      : comment.likesCount + 1,
                );
              }
              return comment;
            }).toList();

            final updatedPost = post.copyWith(comments: updatedComments);
            emit(currentState.copyWith(post: updatedPost));
          }

          // الحالة الثانية: عند فتح ردود تعليق
          else if (state is RepliesLoaded) {
            final currentState = state as RepliesLoaded;
            final replies = currentState.replies;

            final updatedReplies = replies!.map((reply) {
              if (reply.id == event.commentId) {
                final isLiked = reply.isLiked;
                return reply.copyWith(
                  isLiked: !isLiked,
                  likesCount:
                      isLiked ? reply.likesCount - 1 : reply.likesCount + 1,
                );
              }
              return reply;
            }).toList();

            emit(currentState.copyWith(replies: updatedReplies));
          }
        },
      );
    });
    ;

    on<GetRepliesEvent>((event, emit) async {
      final userId = await getUserIdUseCase();

      if (event.commentsIds.isEmpty) {
        emit(RepliesLoaded([]));
        return;
      }
      emit(CommentLoading());

      final result = await getRepliesUseCase(event.commentsIds);
      result.fold(
        (failure) => emit(CommentFailure(failure.errMessage)),
        (replies) {
          final updatedComments = replies.map((comment) {
            final isMyComment = comment.user.id == userId;
            final isLikedComment = comment.likedBy!.contains(userId);

            return comment.copyWith(
                isMyComment: isMyComment, isLiked: isLikedComment);
          }).toList();

          emit(RepliesLoaded(updatedComments));
        },
      );
    });
    on<AddCommentsRequested>((AddCommentsRequested event, emit) async {
      final result = await addComment(
          content: event.comments,
          postId: event.postId,
          repliedTo: event.replyto);

      if (state is PostdetailsLoaded) {
        final currentState = state as PostdetailsLoaded;
        final post = currentState.post;

        result.fold(
          (l) {
            emit(LikeCommentFalier(l.errMessage));
            emit(currentState);

            // emit(currentState.copyWith(errorMessage: "حدث خطأ أثناء الإعجاب"));
            // emit(currentState.copyWith(errorMessage: null));
          },
          (comment) {
            print("💘${comment["comment"]}");
            print("💘${comment["user"]}");
            UserModel userModel = comment["user"]; // تحويل إلى كائن UserModel
            final updatedComments = List<Comment>.from(post.comments)
              ..add(Comment(
                  likesCount: 0,
                  id: comment["comment"],
                  content: event.comments,
                  user: userModel
                      .toEntity(), // ثم استدعاء toEntity() لتحويله إلى كائن User
                  repliedBy: [],
                  likedBy: [],
                  createdAt: DateTime.now()));

            final updatedPost = post.copyWith(comments: updatedComments);
            emit(currentState.copyWith(post: updatedPost));
          },
        );
      } else if (state is RepliesLoaded) {
        final currentState = state as RepliesLoaded;
        final post = currentState.replies;
        result.fold(
          (l) {
            emit(LikeCommentFalier(l.errMessage));
            emit(currentState);

            // emit(currentState.copyWith(errorMessage: "حدث خطأ أثناء الإعجاب"));
            // emit(currentState.copyWith(errorMessage: null));
          },
          (comment) {
                        UserModel userModel = comment["user"]; // تحويل إلى كائن UserModel

            final updatedComments = List<Comment>.from(post!)
           ..add(Comment(
                  likesCount: 0,
                  id: comment["comment"],
                  content: event.comments,
                  user: userModel
                      .toEntity(), // ثم استدعاء toEntity() لتحويله إلى كائن User
                  repliedBy: [],
                  likedBy: [],
                  createdAt: DateTime.now())) ;
            emit(currentState.copyWith(replies: updatedComments));
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
