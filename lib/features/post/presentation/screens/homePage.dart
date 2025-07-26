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
import 'package:social_media_app/features/post/presentation/screens/components/FilterDialog.dart';
import 'package:social_media_app/features/post/presentation/screens/components/PostCard.dart';
import 'package:social_media_app/features/post/presentation/screens/createPost.dart';
import 'package:social_media_app/features/post/presentation/screens/postDetails.dart'
    hide Widget;
import 'package:social_media_app/features/profile/presentation/screens/myProfailPage.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_state.dart';
import 'package:social_media_app/features/realtime/presentation/screens/NotificationsPage.dart';
import 'package:social_media_app/features/search/search_bloc.dart';
import 'package:social_media_app/features/search/search_delegate.dart';
import 'package:social_media_app/features/search/search_repository.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> logs = {};
  Set<dynamic> ratingPostIds = {};
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    logs = sl<TrackerBloc>().getlogs();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {});
      }
    });

    context.read<NotificationBloc>().add(LoadNotificationsEvent());
  }

  void _prepareRatingPosts(List<Post> posts) {
    final count = (posts.length * 0.5).round();
    final indices = _generateUniqueRandomIndices(posts.length, count);
    ratingPostIds = indices.map((i) => posts[i].id).toSet();
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
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: PersonSearchDelegate(
                            SearchBloc(sl<SearchRepository>())));
                  },
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
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          controller: _tabController,
                          tabs: [
                            GestureDetector(
                              onDoubleTap: () {
                                if (_tabController.index == 0) {
                                  _scrollController.animateTo(
                                    0,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Tab(text: 'For You'),
                            ),
                            GestureDetector(
                              onDoubleTap: () {
                                if (_tabController.index == 1) {
                                  _scrollController.animateTo(
                                    0,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Tab(text: 'Following'),
                            ),
                          ],
                          labelColor: Colors.teal,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.teal,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list, color: Colors.grey[700]),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => FilterDialog(),
                          );
                        },
                        tooltip: "Filter",
                      ),
                    ],
                  ),
                ),
              )
            ],
            body: TabBarView(
              controller: _tabController,
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
          if (ratingPostIds.isEmpty && posts.isNotEmpty) {
            _prepareRatingPosts(posts);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ratingPostIds.clear();
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
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = posts[index];
                        final showRating = ratingPostIds.contains(post.id);

                        // final showindex = index % 3 == 0;
                        return Column(
                          children: [
                            PostCard(
                              post: post,
                              showDilog: showRating,
                              onRated: () {
                                // إزالة البوست بعد التقييم
                                setState(() {
                                  ratingPostIds.remove(post.id);
                                });
                              },
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
