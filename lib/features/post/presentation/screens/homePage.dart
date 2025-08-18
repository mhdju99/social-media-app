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
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_state.dart';
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
  bool hasPreparedRatings = false;

  String? selectedGender;
  double minAge = 0;
  double maxAge = 100;

  final List<String> topics = [
    "Anxiety & Stress Management",
    "Depression & Mood Disorders",
    "Relationships & Interpersonal Issues",
    "Self-Esteem & Identity",
    "Trauma & PTSD",
    "Growth, Healing & Motivation",
  ];
  List<String> selectedTopics = [];
  Map<String, dynamic> logs = {};
  Set<dynamic> ratingPostIds = {};
  Set<String> ratedPostIds = {}; // تتبع دائم

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
    final filtered =
        posts.where((post) => !ratedPostIds.contains(post.id)).toList();

    if (filtered.isEmpty) return;

    final count = (filtered.length * 0.3).round();
    final indices = _generateUniqueRandomIndices(filtered.length, count);

    ratingPostIds = indices.map((i) => filtered[i].id).toSet();
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

          return sl<PostBloc>()
            ..add(GetPostsRequested(isRells: false, logs: logs));
        },
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatMessageReceived) {
              //                print("💫${state.message}");
              // NotificationService.showNotification(
              //   title: 'message received a',
              //   body: state.message["content"],

              // );
              // context
              //     .read<NotificationBloc>()
              //     .add(AddNotificationEvent({"from": "", "to": "", "text": "Message Received < ${state.message["content"]} >", "createdAt": DateTime.now() }));
            }
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
                  title:
                      Text('Home', style: TextStyle(color: Colors.grey[800])),
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
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: const Tab(text: 'For You'),
                              ),
                              GestureDetector(
                                onDoubleTap: () {
                                  if (_tabController.index == 1) {
                                    _scrollController.animateTo(
                                      0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: const Tab(text: 'Following'),
                              ),
                            ],
                            labelColor: Colors.teal,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.teal,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.filter_alt,
                                  color: Colors.grey[700]),
                              onPressed: () {
                                final postBloc = context.read<
                                    PostBloc>(); // ✅ تأخذ الموجود وليس تنشئ جديد

                                showDialog(
                                  context: context,
                                  builder: (dialogContext) =>
                                      BlocProvider.value(
                                    value:
                                        postBloc, // ✅ نمرر الـ Bloc الموجود بالفعل
                                    child: StatefulBuilder(
                                      builder: (context, setStateDialog) {
                                        return AlertDialog(
                                          title: const Text('Filter Posts'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // ✅ Gender
                                                const Text(
                                                    'Post Owner Gender:'),
                                                Row(
                                                  children: [
                                                    Radio<String>(
                                                      value: 'male',
                                                      groupValue:
                                                          selectedGender,
                                                      onChanged: (value) {
                                                        setStateDialog(() =>
                                                            selectedGender =
                                                                value!);
                                                      },
                                                    ),
                                                    const Text('Male'),
                                                    Radio<String>(
                                                      value: 'female',
                                                      groupValue:
                                                          selectedGender,
                                                      onChanged: (value) {
                                                        setStateDialog(() =>
                                                            selectedGender =
                                                                value!);
                                                      },
                                                    ),
                                                    const Text('Female'),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),

                                                // ✅ Age Range
                                                Text(
                                                    'Post Owner Age: ${minAge.round()} - ${maxAge.round()}'),
                                                RangeSlider(
                                                  min: 0,
                                                  max: 100,
                                                  divisions: 90,
                                                  labels: RangeLabels(
                                                    '${minAge.round()}',
                                                    '${maxAge.round()}',
                                                  ),
                                                  values: RangeValues(
                                                      minAge, maxAge),
                                                  onChanged:
                                                      (RangeValues values) {
                                                    setStateDialog(() {
                                                      minAge = values.start;
                                                      maxAge = values.end;
                                                    });
                                                  },
                                                ),

                                                const SizedBox(height: 20),

                                                // ✅ Topics
                                                const Text('Topics:'),
                                                Wrap(
                                                  spacing: 8.0,
                                                  children: topics.map((topic) {
                                                    final isSelected =
                                                        selectedTopics
                                                            .contains(topic);
                                                    return ChoiceChip(
                                                      label: Text(topic),
                                                      selected: isSelected,
                                                      onSelected: (selected) {
                                                        setStateDialog(() {
                                                          if (selected) {
                                                            selectedTopics
                                                                .add(topic);
                                                            print(
                                                                "🈹$selectedTopics");
                                                          } else {
                                                            selectedTopics
                                                                .remove(topic);
                                                            print(
                                                                "🈹$selectedTopics");
                                                          }
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {});
                                                context.read<PostBloc>().add(
                                                      GetPostsRequested(
                                                        isRells: false,
                                                        gender: selectedGender,
                                                        maxAge: maxAge.toInt(),
                                                        minAge: minAge.toInt(),
                                                        categories:
                                                            selectedTopics,
                                                        logs: logs,
                                                      ),
                                                    );
                                                Navigator.of(dialogContext)
                                                    .pop();
                                              },
                                              child: const Text('Apply'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(dialogContext)
                                                      .pop(),
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            Visibility(
                                visible: (selectedGender != null ||
                                    selectedTopics.isNotEmpty ||
                                    minAge != 0 ||
                                    maxAge != 100),
                                child: IconButton(
                                    onPressed: () {
                                      selectedGender = null;
                                      selectedTopics = [];
                                      minAge = 0;
                                      maxAge == 100;
                                      setState(() {
                                        context.read<PostBloc>().add(
                                            GetPostsRequested(
                                                isRells: false,
                                                categories: selectedTopics,
                                                gender: selectedGender,
                                                logs: logs,
                                                maxAge: maxAge.toInt(),
                                                minAge: minAge.toInt()));
                                      });
                                    },
                                    icon: const Icon(Icons.cancel_outlined,
                                        color: Colors.red)))
                          ],
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
                    context.read<PostBloc>().add(GetPostsRequested(
                          isRells: false,
                        ));
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
          );
        } else if (state is PostsLoaded) {
          List<Post> posts;
          List<String> postIds = state.posts.map((post) => post.id).toList();
          if (state.posts.length < 1) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" no posts"),
                  IconButton(
                    onPressed: () {
                      context.read<PostBloc>().add(GetPostsRequested(
                            isRells: false,
                          ));
                    },
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
            );
          }
          if (isFollowing) {
            posts = state.posts
                .where(
                  (element) => element.publisher.isfollowMe == isFollowing,
                )
                .toList();
          } else {
            posts = state.posts;
          }
          if (!hasPreparedRatings && posts.isNotEmpty) {
            _prepareRatingPosts(posts);
            print("💦$ratingPostIds");

            hasPreparedRatings = true;
          }
          final logs = sl<TrackerBloc>().getlogs();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                ratingPostIds.clear();
                hasPreparedRatings =
                    false; // ✅ حتى نولد من جديد عند التحميل فقط
              });
              context.read<PostBloc>().add(GetPostsRequested(
                  isRells: false,
                  categories: selectedTopics,
                  existingPostIds: postIds,
                  gender: selectedGender,
                  logs: logs,
                  maxAge: maxAge.toInt(),
                  minAge: minAge.toInt()));
              // context.read<TrackerBloc>().add(SendLogsEvent());
              // WidgetsBinding.instance.addPostFrameCallback((_) {

              // });
              print("💫$logs");
              print("💫$postIds");
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
                                  ratedPostIds.add(post.id); // نمنع إعادة ظهوره

                                  print("💦$ratingPostIds");
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
