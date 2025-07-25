// 🔷 Comments Section
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_media_app/core/constants/UserActions%20.dart';
import 'package:social_media_app/core/constants/category.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/core/utils/image_viewer_helper.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/usecases/like_unlike_post.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/components/ReelVideoPlayer.dart';
import 'package:social_media_app/features/post/presentation/screens/components/buildComment.dart';
import 'package:social_media_app/features/post/presentation/screens/modifyPost..dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:social_media_app/features/profile/presentation/screens/myProfailPage.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';

class PostDetailsPage extends StatefulWidget {
  final String postid;
  const PostDetailsPage({super.key, required this.postid});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  TextEditingController commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isSubmitting = false;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showPostOptions(
    BuildContext contexta,
    PostDetails post,
  ) {
    showModalBottomSheet(
      context: contexta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 3),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                child: ListTile(
                  leading: const Icon(
                    Icons.mode_edit_outline_outlined,
                  ),
                  title: const Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context, 'refresh'); // إغلاق الـ BottomSheet

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ModifyPostPage(
                                post: post,
                              )),
                    );
                    if (result == 'refresh') {
                      contexta
                          .read<PostBloc>()
                          .add(GetPostRequested(widget.postid));
                    }
                  },
                ),
              ),
              Card(
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.delete_outline_rounded,
                      color: Colors.red),
                  title: const Text(
                    "Delete",
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context, 'refresh'); // إغلاق الـ BottomSheet

                    contexta.read<PostBloc>().add(DeletePostRequested(post.id));
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostBloc>()..add(GetPostRequested(widget.postid)),
      child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state is LikeCommentFalier) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 4,
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                ),
              );
            } else if (state is delDone) {
              Navigator.pop(context, 'refresh');
            }
          },
          buildWhen: (previous, current) => current is! LikeCommentFalier,
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Post Details"),
                  backgroundColor: Colors.white,
                ),
                body: () {
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
                                    .add(GetPostRequested(widget.postid));
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    );
                  } else if (state is PostdetailsLoaded) {
                    return SafeArea(
                      bottom: true,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(3),
                              children: [
                                // 🔷 Main Post Content
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (state.post.isMyPost!) {
                                              final result = Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const ProfileScreen()),
                                              );
                                              return;
                                            }
                                            final result = Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      UserProfileScreen(
                                                          userId: state.post
                                                              .publisher.id)),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${state.post.publisher.profileImage}",
                                                ),
                                                radius: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      state.post.publisher
                                                          .userName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[800])),
                                                  Text(
                                                      formatPostTime(
                                                          state.post.createdAt),
                                                      style: TextStyle(
                                                          color: Colors.grey[500],
                                                          fontSize: 12)),
                                                ],
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon:
                                                    const Icon(Icons.more_horiz),
                                                onPressed: () => _showPostOptions(
                                                    context, state.post),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(state.post.description,
                                            style: TextStyle(
                                                color: Colors.grey[700])),
                                        const SizedBox(height: 12),
                                        state.post.reelFlag
                                            ? ReelVideoPlayer(
                                                videoUrl:
                                                    "${EndPoints.baseUrl}/posts/get-file?filesName=${state.post.images.first}&postId=${state.post.id}",
                                              )
                                            : PostImagesGrid(
                                                imageUrls: state.post.images,
                                                postId: state.post.id,
                                              ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                LikeButtonWithCount(
                                                    postId: widget.postid),
                                                const SizedBox(width: 12),
                                                Icon(Icons.chat_bubble_outline,
                                                    size: 18,
                                                    color: Colors.grey[500]),
                                                const SizedBox(width: 4),
                                                Text(
                                                    state.post.comments.isEmpty
                                                        ? ''
                                                        : state
                                                            .post.comments.length
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey[600])),
                                                const SizedBox(width: 12),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                      
                                const SizedBox(height: 10),
                                // const Text("Comments",
                                //     style:
                                //         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      
                                // const SizedBox(height: 10),
                                ...state.post.comments.map((c) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: buildComment(
                                        comment: c,
                                        postid: widget.postid,
                                        topic: state.post.topic,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                      
                          // 🔷 Comment Input
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(color: Colors.grey.shade300)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CustomTextField(
                                      prefixIcon: const Icon(Icons.message),
                                      text: "   Add a comment...",
                                      controller: commentController,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: isSubmitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : const Icon(Icons.send,
                                          color: Colors.blue),
                                  onPressed: () async {
                                    final text = commentController.text;
                                    if (text.trim().isEmpty) return;
                      
                                    setState(() => isSubmitting = true);
                      
                                    context.read<PostBloc>().add(
                                        AddCommentsRequested(
                                            text, widget.postid, null));
                                    context.read<TrackerBloc>().add(
                                        LogActionEvent(
                                            category: category[state.post.topic]!,
                                            action: UserActions.comment));
                                    commentController.clear();
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                      
                                    setState(() => isSubmitting = false);
                                    WidgetsBinding.instance.addPostFrameCallback(
                                        (_) => _scrollToBottom());
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }());
          }),
    );
  }
}

class LikeButtonWithCount extends StatelessWidget {
  final String postId;
  const LikeButtonWithCount({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final isLiked = context.select<PostBloc, bool>(
      (bloc) => bloc.state is PostdetailsLoaded
          ? (bloc.state as PostdetailsLoaded).post.isLiked
          : false,
    );

    final likeCount = context.select<PostBloc, int>(
      (bloc) => bloc.state is PostdetailsLoaded
          ? (bloc.state as PostdetailsLoaded).post.likesCount
          : 0,
    );

    return Row(
      children: [
        InkWell(
          onTap: () {
            context.read<PostBloc>().add(ToggleLikePostRequested(postId));
          },
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 18,
            color: isLiked ? Colors.red : Colors.grey[500],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          likeCount == 0 ? '' : likeCount.toString(),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class PostImagesGrid extends StatelessWidget {
  final List<String> imageUrls;
  final String postId;

  const PostImagesGrid(
      {super.key, required this.imageUrls, required this.postId});

  @override
  Widget build(BuildContext context) {
    final int total = imageUrls.length;
    final String imageUrl =
        "${EndPoints.baseUrl}/posts/get-file?filesName=${imageUrls[0]}&postId=$postId";

    if (total == 1) {
      return InkWell(
        onTap: () {
          showFullImage(context, imageUrl);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 350,
            height: 200,
            child: Image(
              fit: BoxFit.cover,
              image: Image.network(imageUrl).image,
            ),
          ),
        ),
      );
    }

    if (total == 2) {
      return Row(
        children: imageUrls.take(2).map((url) {
          final String imageUrl =
              "${EndPoints.baseUrl}/posts/get-file?filesName=$url&postId=$postId";

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: () {
                  showFullImage(context, imageUrl);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: imageUrls.length > 4 ? 4 : imageUrls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final String imageUrl =
            "${EndPoints.baseUrl}/posts/get-file?filesName=${imageUrls[index]}&postId=$postId";

        return InkWell(
          onTap: () {
            showFullImage(context, imageUrl);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
