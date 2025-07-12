import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(const GetMyProfileEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // if (state is ProfileFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       elevation: 4,
          //       content: Text(state.message),
          //       behavior: SnackBarBehavior.floating,
          //       backgroundColor: Colors.redAccent,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       duration: const Duration(seconds: 2),
          //       margin: const EdgeInsets.all(16),
          //     ),
          //   );
          // }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
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
                            context.read<ProfileBloc>().add(const GetMyProfileEvent());
                          },
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                );
              } else if (state is ProfileSuccess<UserProfile>) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundImage: NetworkImage(
                          "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${state.data.profileImage}",
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        '${state.data.firstName}${state.data.lastName}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.verified, color: Colors.teal),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: const StadiumBorder(),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('متابعة'),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text('رسالة'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('طوكيو',
                              style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 6),
                          const Text('•', style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 6),
                          Text('879 متابِع',
                              style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 6),
                          const Text('•', style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 6),
                          Text('774 متابَع',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'أهلاً! أنا طبيبة قلب معتمدة أقيم في طوكيو! إذا كان لديك مشكلة في القلب، فلا تتردد في مراسلتي.💖🩺',
                          style: TextStyle(color: Colors.grey[800]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('الكل',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold)),
                          Text('المنشورات'),
                          Text('الصور'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) => Container(
                            color: Colors.grey[300],
                          ),
                          itemCount: 6,
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
}
