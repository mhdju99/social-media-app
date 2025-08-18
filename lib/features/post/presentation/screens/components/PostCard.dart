// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/core/constants/UserActions%20.dart';
import 'package:social_media_app/core/constants/category.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/components/PostRatingCard.dart';
import 'package:social_media_app/features/post/presentation/screens/postDetails.dart'
    hide Widget;
import 'package:social_media_app/features/profile/presentation/screens/myProfailPage.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';

import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostCard extends StatefulWidget {
  final Post post;
  bool showDilog;
  final VoidCallback? onRated;

  PostCard({
    Key? key,
    required this.post,
    required this.showDilog,
    this.onRated,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Timer? _viewTimer;
  Timer? _dilogTimer;
  bool _hasLoggedView = false;

  void showRatingDialog(
      {required BuildContext context,
      required String postId,
      required int cat}) {
    ;
  }

  void _startViewTimer() {
    if (_hasLoggedView || _viewTimer != null) return;

    _viewTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Future.microtask(() {
        if (mounted) {
          context.read<TrackerBloc>().add(LogActionEvent(
                category: category[widget.post.topic]!,
                action: UserActions.view,
              ));
        }
      });
    });
    // _dilogTimer = Timer(const Duration(seconds: 0), () {
    //   if (widget.showDilog) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       _ratingView = true;
    //       if (mounted) {
    //         // showRatingDialog(
    //         //   cat: int.parse(category[widget.post.topic]!.split(" ").last),
    //         //   context: context,
    //         //   postId: widget.post.id,
    //         // );
    //       }
    //     });
    //   }
    // });
  }

  void _cancelViewTimer() {
    _viewTimer?.cancel();
    _viewTimer = null;
    _dilogTimer?.cancel();
    _dilogTimer = null;
  }

  @override
  void dispose() {
    _cancelViewTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("post-${widget.post.id}"),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.8) {
          _startViewTimer();
        } else {
          _cancelViewTimer();
        }
      },
      child: Column(
        children: [
          Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                   
                    child: Row(
                      children: [
                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //     "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${widget.post.publisher.profileImage}",
                        //   ),
                        //   radius: 20,
                        // ),
                        InkWell(
                           onTap: () {
                      if (widget.post.hiddenFlag == true) {
                        return;
                      }
                      if (widget.post.isMyPost != null) {
                        if (widget.post.isMyPost!) {
                          final result = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen()),
                          );
                          return;
                        }
                      }
                      final result = Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserProfileScreen(
                                userId: widget.post.publisher.id)),
                      );
                    },
                          child: CircleAvatar(
                            backgroundImage: (widget.post.hiddenFlag == false)
                                ? (widget.post.publisher.profileImage.isNotEmpty)
                                    ? NetworkImage(
                                        "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${widget.post.publisher.profileImage}",
                                      )
                                    : const AssetImage(
                                        "assets/images/default_avatar.png")
                                : const AssetImage(
                                    "assets/images/anonymous-user.png"),
                          
                            // backgroundImage: (!comment.hiddenFlag)?: AssetImage("assets/images/anonymous-user.png"),
                            radius: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                   onTap: () {
                      if (widget.post.hiddenFlag == true) {
                        return;
                      }
                      if (widget.post.isMyPost != null) {
                        if (widget.post.isMyPost!) {
                          final result = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen()),
                          );
                          return;
                        }
                      }
                      final result = Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserProfileScreen(
                                userId: widget.post.publisher.id)),
                      );
                    },
                                  child: Text(
                                      (widget.post.hiddenFlag == true)
                                          ? "Anonymous user"
                                          : widget.post.publisher.userName,
                                  
                                      // widget.post.publisher.userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800])),
                                ),
                                // const Icon(
                                //   Icons.verified,
                                //   color: Colors.blue,
                                // )
                              ],
                            ),
                            Text(formatPostTime(widget.post.createdAt),
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final result = Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                PostDetailsPage(postid: widget.post.id)),
                      );
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(widget.post.description,
                              style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 12),
                          PostImagesGrid(
                            imageUrls: widget.post.images,
                            postId: widget.post.id,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<PostBloc>().add(
                                      ToggleLikePostRequested(widget.post.id));
                                  if (!widget.post.isLiked) {
                                    context.read<TrackerBloc>().add(
                                        LogActionEvent(
                                            category:
                                                category[widget.post.topic]!,
                                            action: UserActions.like));
                                  }
                                },
                                child: Icon(
                                  widget.post.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 22,
                                  color: widget.post.isLiked
                                      ? Colors.red
                                      : Colors.grey[500],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.post.likesCount == 0
                                    ? ''
                                    : widget.post.likesCount.toString(),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              final result = Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PostDetailsPage(
                                        postid: widget.post.id)),
                              );
                            },
                            child: Icon(Icons.chat_bubble_outline,
                                size: 20, color: Colors.grey[500]),
                          ),
                          const SizedBox(width: 4),
                          Text(
                              widget.post.comments.isEmpty
                                  ? ''
                                  : widget.post.comments.length.toString(),
                              style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.showDilog,
            child: Column(
              children: [
                Center(
                  child: Icon(Icons.arrow_upward_outlined),
                ),
                PostRatingCard(
                  onRated: (rating) {
                    context.read<TrackerBloc>().add(SendFeedbackEvent(
                        rating: rating,
                        category: int.parse(
                            category[widget.post.topic]!.split(" ").last)));
                    widget.onRated?.call();
                    setState(() {
                      widget.showDilog = false;
                      // print("Rated post $postId with $selectedRating");
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
