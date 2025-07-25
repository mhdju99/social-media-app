// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/core/constants/UserActions%20.dart';
import 'package:social_media_app/core/constants/category.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/utils/notifications_service.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/createPost.dart';
import 'package:social_media_app/features/post/presentation/screens/postDetails.dart'
    hide Widget;
import 'package:social_media_app/features/profile/presentation/screens/myProfailPage.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_state.dart';
import 'package:social_media_app/features/realtime/presentation/screens/NotificationsPage.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic> logs = {};
  @override
  void initState() {
    super.initState();
    logs = sl<TrackerBloc>().getlogs();

    context.read<NotificationBloc>().add(LoadNotificationsEvent());
  }

  _generateUniqueRandomIndices(int max, int count) {
    final random = Random();
    final Set<int> indices = {};
    while (indices.length < count && indices.length < max) {
      indices.add(random.nextInt(max));
    }
    return indices;
  }

  Widget buildNotificationIcon(int count) {
    return Stack(
      children: [
        const Icon(Icons.notifications, size: 30, color: Colors.black87),
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            bottom: 5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                '$count',
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // For You + Following
      child: BlocProvider(
        create: (context) {
          print("💫$logs");

          return sl<PostBloc>()..add(const GetPostsRequested(isRells: false));
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                elevation: 1,
                title: Text('Home', style: TextStyle(color: Colors.grey[800])),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.search, color: Colors.grey[600]),
                  onPressed: () {},
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationsPage()),
                      );
                    },
                    child: BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationLoaded) {
                          final int count = state.notifications
                              .where((e) => !e.isRead)
                              .length;
                          return buildNotificationIcon(count);
                        } else {
                          return buildNotificationIcon(0);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 15)
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "For You"),
                    Tab(text: "Follower"),
                  ],
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.teal,
                ),
              )
            ],
            body: TabBarView(
              children: [
                _buildPostsView(isFollowing: false),
                _buildPostsView(isFollowing: true),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: SizedBox(
            height: 55,
            width: 55,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreatePostPage()),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostsView({required bool isFollowing}) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                IconButton(
                  onPressed: () {
                    context
                        .read<PostBloc>()
                        .add(const GetPostsRequested(isRells: false));
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
          );
        } else if (state is PostsLoaded) {
          final List<Post> posts;
          if (isFollowing) {
            posts = state.posts
                .where(
                  (element) => element.publisher.isfollowMe == isFollowing,
                )
                .toList();
          } else {
            posts = state.posts;
          }
          return RefreshIndicator(
            onRefresh: () async {
              final logs = sl<TrackerBloc>().getlogs();
              // context.read<TrackerBloc>().add(SendLogsEvent());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<PostBloc>()
                    .add(const GetPostsRequested(isRells: false));
              });
              print("💫$logs");
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = posts[index];
                        final Set<int> ratingpost =
                            _generateUniqueRandomIndices(
                                posts.length, (posts.length * 0.5).round());

                        // final showindex = index % 3 == 0;
                        return Column(
                          children: [
                            PostCard(
                              post: post,
                              showDilog: ratingpost.contains(index),
                            ),
                          ],
                        );
                      },
                      childCount: posts.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final Post post;
  bool showDilog;

  PostCard({
    Key? key,
    required this.post,
    required this.showDilog,
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
    int selectedRating = 0;
    final List<String> ratingLabels = [
      "Terrible", // 1
      "Very Bad", // 2
      "Bad", // 3
      "Poor", // 4
      "Below Average", // 5
      "Average", // 6
      "Good", // 7
      "Very Good", // 8
      "Excellent", // 9
      "Perfect" // 10
    ];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("How do you rate this post?",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 3,
                children: List.generate(10, (index) {
                  int rating = index + 1;
                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(rating.toString()),
                    selected: selectedRating == rating,
                    selectedColor: Colors.blue,
                    onSelected: (_) {
                      setState(() {
                        selectedRating = rating;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              if (selectedRating > 0)
                Text(
                  ratingLabels[selectedRating - 1],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: selectedRating > 0
                  ? () {
                      // send rating here
                      print("Rated post $postId with $selectedRating");
                      Navigator.pop(context);
                      context.read<TrackerBloc>().add(SendFeedbackEvent(
                          rating: selectedRating, category: cat));
                    }
                  : null,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
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
                    onTap: () {
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${widget.post.publisher.profileImage}",
                          ),
                          radius: 20,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(widget.post.publisher.userName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800])),
                                const Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                )
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
                    setState(() {
                      widget.showDilog = false;
                      // print("Rated post $postId with $selectedRating");
                      context.read<TrackerBloc>().add(
                          SendFeedbackEvent(rating: rating, category: int.parse(
                              category[widget.post.topic]!.split(" ").last)));
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

class PostRatingCard extends StatefulWidget {
  final void Function(int rating) onRated;

  const PostRatingCard({super.key, required this.onRated});

  @override
  _PostRatingCardState createState() => _PostRatingCardState();
}

class _PostRatingCardState extends State<PostRatingCard> {
  int? selectedRating;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How do you rate this post?",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            GridView.count(
              padding: const EdgeInsets.only(top: 5),
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 2, // لضبط حجم الأزرار
              children: List.generate(10, (index) {
                final rating = index + 1;
                final isSelected = selectedRating == rating;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = rating;
                      widget.onRated(rating);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.blue : Colors.grey[200],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: Text(rating.toString()),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
