import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/core/utils/image_viewer_helper.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/postDetails.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:social_media_app/features/profile/presentation/screens/EditProfilePage.dart';
import 'package:social_media_app/features/profile/presentation/screens/FollowersFollowingPage.dart';
import 'package:social_media_app/features/profile/presentation/screens/components/CustomDrawer.dart';
import 'package:social_media_app/features/profile/presentation/screens/edittopicPage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(const GetMyProfileEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(

            
            endDrawer: const CustomDrawer(),
            appBar: AppBar(
              actions: [
                SizedBox(width: 10,),
             InkWell(
                    onTap: () {
                      context
                          .read<ProfileBloc>()
                          .add(const GetMyProfileEvent());
                    },
                    child: const Icon(Icons.refresh, color: Colors.black)),
                    Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                )
              ],
              title: Text(
                state is ProfileSuccess<UserProfile> ? state.data.userName : "",
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
            ),
            backgroundColor: Colors.grey[200],
            body: () {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      IconButton(
                        onPressed: () {
                          context
                              .read<ProfileBloc>()
                              .add(const GetMyProfileEvent());
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileSuccess<UserProfile>) {
                final user = state.data;
                return DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      _buildProfileHeader(user, context),
                      _buildProfileButtons(context, user),
                      const TabBarWidget(),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildPostGrid(user, false), // منشورات عادية
                            _buildPostGrid(user, true), // منشورات Reels فقط
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }(),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile user, BuildContext context) {
    final String imageUrl =
        "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${user.profileImage}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (user.profileImage.isNotEmpty) {
                showFullImage(context, imageUrl);
              }
            },
            child: CircleAvatar(
              radius: 40,
              backgroundImage: user.profileImage.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : const AssetImage("assets/images/default_avatar.png")
                      as ImageProvider,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(
                    count: user.posts.length.toString(),
                    label: 'Posts',
                    ontap: () {}),
                _StatColumn(
                  count: user.followers.length.toString(),
                  label: 'Followers',
                  ontap: () {
                    print("💘");
                    print(user.followers);
                    if (user.followers.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FollowersPage(
                              data: user.followers, type: "Followers"),
                        ),
                      );
                    }
                  },
                ),
                _StatColumn(
                  count: user.following.length.toString(),
                  label: 'Following',
                  ontap: () {
                    if (user.following.isNotEmpty) {
                      print("💘");
                      print(user.following);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FollowersPage(
                              data: user.following, type: "Following"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButtons(BuildContext context, UserProfile user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${user.firstName} ${user.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(user.about.toString()),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditProfilePage(user: user)),
                    );
                    if (result == 'refresh') {
                      context
                          .read<ProfileBloc>()
                          .add(const GetMyProfileEvent());
                    }
                  },
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            EditTopicPage(selectedTopic: user.preferredTopics)),
                  );
                  if (result == 'refresh') {
                    context.read<ProfileBloc>().add(const GetMyProfileEvent());
                  }
                },
                child: const Text('Edit preferred Topics'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostGrid(UserProfile user, bool isReel) {
    final filteredPosts =
        user.posts.where((post) => post.reelFlag == isReel).toList();

    if (filteredPosts.isEmpty) {
      return const Center(child: Text("No posts found"));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
     // يمنع التمرير

        itemCount: filteredPosts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final post = filteredPosts[index];

          final fileUrl =
              "${EndPoints.baseUrl}/posts/get-file?filesName=${post.images[0]}&postId=${post.id}";

          return InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PostDetailsPage(postid: post.id)),
              );
              if (result == 'refresh') {
                context.read<ProfileBloc>().add(const GetMyProfileEvent());
              }
            },
            child: post.reelFlag
                ? Stack(
                    children: [
                      Container(
                        color: Colors.black,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.play_circle_fill,
                              color: Colors.white70, size: 40),
                        ),
                      )
                    ],
                  )
                : Image.network(fileUrl, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String count;
  final String label;
  final VoidCallback? ontap;

  const _StatColumn({required this.count, required this.label, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Text(count,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicatorColor: Colors.black,
      tabs: [
        Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
        Tab(icon: Icon(Icons.movie, color: Colors.black)),
      ],
    );
  }
}
