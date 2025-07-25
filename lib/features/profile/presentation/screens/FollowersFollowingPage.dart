// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/features/post/domian/entities/user_entity.dart';

import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';

import '../../../../core/injection_container copy 2.dart';

class FollowersPage extends StatelessWidget {
  final String type;
  final List<String> data;
  const FollowersPage({
    super.key,
    required this.type,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProfileBloc>()..add(GetProfilePhotoAndNameEvent(data)),
      child: Scaffold(
        appBar: AppBar(title: Text(type)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
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
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                );
              } else if (state is ProfileSuccess<List<User>>) {
                return ListView.separated(
                  itemCount: state.data.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 5,
                  ),
                  itemBuilder: (context, index) {
                    final user = state.data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserProfileScreen(
                                userId: user.id,
                              ),
                            ));
                      },
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: (user.profileImage.isNotEmpty)
                                ? NetworkImage(
                                    "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${user.profileImage}",
                                  )
                                : const AssetImage(
                                    "assets/images/default_avatar.png"),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              // نفس الشيء: فتح البروفايل
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (_) => UserProfilePage(userName: user["name"]),
                              //     ));
                            },
                            child: Text(
                              user.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          // trailing: ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: user["isFollowing"]
                          //         ? Colors.grey[200]
                          //         : Colors.blue,
                          //     foregroundColor: user["isFollowing"]
                          //         ? Colors.black
                          //         : Colors.white,
                          //     padding: const EdgeInsets.symmetric(horizontal: 12),
                          //     minimumSize: const Size(10, 36),
                          //   ),
                          //   onPressed: () {
                          //     // تغيير حالة المتابعة
                          //   },
                          //   child: Text(user["isFollowing"] ? "متابع" : "متابعة"),
                          // ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox(
                  child: Text("sdsd"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
