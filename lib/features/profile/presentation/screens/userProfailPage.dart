import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

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
            appBar: AppBar(
              title:
                  const Text('username', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 1,
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                    } else if (value == 'delete') {
                      // تنفيذ الحذف
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'block',
                      child: Text(
                        "block",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.grey[100],
            body: () {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // else if (state is ProfileFailure) {
              //   return Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //          Text(state.message),
              //         IconButton(
              //             onPressed: () {
              //               context.read<ProfileBloc>().add(const GetMyProfileEvent());
              //             },
              //             icon: const Icon(Icons.refresh))
              //       ],
              //     ),
              //   );
              // }
              // else
              //  if (state is ProfileSuccess<UserProfile>)
              {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      _buildProfileButtons(),
                      _buildTabBar(),
                      _buildPostGrid(),
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

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: true ? Colors.blue : Colors.grey,
                    width: 3,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "${EndPoints.baseUrl}/users/profile-image?profileImagePath=/uploads/profiles/6856e116dc9c59efed7dd4d5/6856e116dc9c59efed7dd4d5.jpg",
                    ) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                bottom: 1,
                child: Icon(Icons.medical_services_rounded,
                    color: Colors.blue, size: 20),
              )
            ],
          ),
          // SizedBox(width: 10),
          const Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatColumn(count: '35', label: 'Posts'),
              _StatColumn(count: '1.2K', label: 'Followers'),
              _StatColumn(count: '890', label: 'Following'),
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildProfileButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Muhammed Aljumaat",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text("sadasdasdasdasdasd"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // تابع أو ألغِ المتابعة
                  },
                  child: const Text(false ? 'إلغاء المتابعة' : 'متابعة'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.person_add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return const TabBarWidget();
  }

  Widget _buildPostGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => Container(
          color: Colors.grey[300],
        ),
        itemCount: 6,
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String count;
  final String label;

  const _StatColumn({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
            Tab(icon: Icon(Icons.movie, color: Colors.black)),
          ],
        ),
      ],
    );
  }
}
