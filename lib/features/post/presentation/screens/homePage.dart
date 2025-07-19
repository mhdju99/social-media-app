import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/entities/post_entity.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/createPost.dart';
import 'package:social_media_app/features/post/presentation/screens/postDetails.dart'
    hide Widget;
import 'package:social_media_app/features/profile/presentation/screens/myProfailPage.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum PostCategory { all, images, videos, articles }

extension PostCategoryExt on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.all:
        return 'All';
      case PostCategory.images:
        return 'Images';
      case PostCategory.videos:
        return 'Videos';
      case PostCategory.articles:
        return 'Articles';
    }
  }
}

class _HomepageState extends State<Homepage> {
  PostCategory _selectedCategory = PostCategory.all;
  Widget _buildChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: PostCategory.values.map((category) {
        return Container(
          child: ChoiceChip(
            label: Text(
              category.label,
            ),
            selected: _selectedCategory == category,
            showCheckmark: false,
            surfaceTintColor: Colors.black,
            elevation: 1,
            side: BorderSide.none,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            selectedColor: const Color.fromARGB(255, 0, 224, 202),
            disabledColor: Colors.grey,
            backgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.all(10),
            labelStyle: TextStyle(
                color: _selectedCategory == category
                    ? Colors.white
                    : Colors.black),
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<PostBloc>()..add(GetPostsRequested(isRells: false)),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePostPage()),
              // MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text('المجتمع', style: TextStyle(color: Colors.grey[800])),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.grey[600]),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            // if (state is LikeCommentFalier) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       elevation: 4,
            //       content: Text(state.message),
            //       behavior: SnackBarBehavior.floating,
            //       backgroundColor: Colors.black87,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       duration: const Duration(seconds: 2),
            //       margin: const EdgeInsets.all(16),
            //     ),
            //   );
            // } else if (state is delDone) {
            //   Navigator.pop(context, 'refresh');
            // }
          },
          buildWhen: (previous, current) => current is! LikeCommentFalier,
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("somthig wrong"),
                    IconButton(
                        onPressed: () {
                          context
                              .read<PostBloc>()
                              .add(GetPostsRequested(isRells: false));
                        },
                        icon: const Icon(Icons.refresh))
                  ],
                ),
              );
            } else if (state is PostsLoaded) {
              final posts = state.posts;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.grey[100],
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildChips(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = posts[index];
                          return PostCard(post: post);
                        },
                        childCount: posts.length,
                      ),
                    ),
                  ),
                ],
              );
              ;
            } else {
              return SizedBox();
            }

            ;
          },
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;

  const FilterChipWidget(
      {super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        backgroundColor: selected ? Colors.teal : Colors.grey[200],
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (post.isMyPost!) {
                  final result = Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileScreen()),
                  );
                  return;
                }
                final result = Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          UserProfileScreen(userId: post.publisher.id)),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${post.publisher.profileImage}",
                    ),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.publisher.userName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800])),
                      Text(formatPostTime(post.createdAt),
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12)),
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
                      builder: (_) => PostDetailsPage(postid: post.id)),
                );
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(post.description,
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    PostImagesGrid(
                      imageUrls: post.images,
                      postId: post.id,
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
                    LikeButtonWithCount(postId: post.id),
                    const SizedBox(width: 12),
                    Icon(Icons.chat_bubble_outline,
                        size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(post.comments.length.toString(),
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
