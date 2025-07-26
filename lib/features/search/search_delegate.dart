import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/features/authentication/data/models/user_model/user_model.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';
import 'package:social_media_app/features/search/SimpleUserModel.dart';
import 'package:social_media_app/features/search/search_bloc.dart';
import 'package:social_media_app/features/search/search_event.dart';
import 'package:social_media_app/features/search/search_state.dart';

class PersonSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;

  PersonSearchDelegate(this.searchBloc);

  @override
  String get searchFieldLabel => 'Search people...';

  @override
  void showResults(BuildContext context) {
    searchBloc.add(SearchQueryChanged(query));
    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // إلغاء الاقتراحات — عرض صفحة فارغة فقط
    return const SizedBox.shrink();
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          if (state.results.isEmpty)
            return const Center(child: Text('No results'));
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                SimpleUserModel user = state.results[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserProfileScreen(
                            userId: user.id!,
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage: (user.profileImage!.isNotEmpty)
                              ? NetworkImage(
                                  "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${user.profileImage}",
                                )
                              : const AssetImage(
                                  "assets/images/default_avatar.png"),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(
                              "@${user.userName!}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                          ],
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
                  ),
                );
              },
            ),
          );
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Enter a keyword and search'));
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              }),
      ];

  @override
  Widget? buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));
}
