// 🔷 Comments Section
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/domian/usecases/like_unlike_post.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  TextEditingController commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isSubmitting = false;
  var username = 'د. حكيم الحكيم';
  var time = 'منذ 5 دقائق';
  var content =
      'كنت أعاني من صداع شديد لأسابيع، ولكن بعد تجربة بعض النصائح من الدكتورة الحكيمة أ.ي، أشعر بتحسن كبير! #وداعا_للصداع #نصائح_طبية';
  var avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAKvt_h7XNeQuygS26VtcqtMYhuOMRv8kgOwb9eKQYtdWyDXKCSCE_uo_FHSlQqiznAH-Pdw6YxiIA6Pw1iXaJj1-OMS3bxPgxkkpmcdCwgxbIIBSXB5osonvYf2ZQTqq4RunmRayPTzknDXaMPU5P3uvzvmEnXOsNqNbBGzabTaPXCZ3bB4fef1Jwiv0mkbPb9xZcri9NlYwRYHQSEGPRQeD5BTNNX_2lV_VL2UO-WuaKgdNuRPmZ7YYjI0_0PlqdZY_n4Omw-Dg0';
  var imageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAjPhKdfw3TPm63nmopt6yWe_LyrLTt3Ug8q5409WxggdrIJiFC1uIP-SY2wQN7Sf9ApJ6Wr67xO3pzNuud1zZsCH1yhtaiN2xABlI_4onQe-g-MxRcLoD6RsDlh-Zt7JvdUxcrFw0BuVA6rJiQbbHY8Xjw1HMnZQruHJYkckaBp3vDeqpFajePIHs52Sf7vgpjyBKjDuPRCwijn6dDaJGShjCPNcdQBZVtPJUfcEjD4XyFnlW4AqR5TEKOWSxVhbtOKNb4u3muYw4';
  var likes = '1.8 ';
  var commentsz = '235';
  List<Map<String, dynamic>> comments = [
    {
      "author": "John Doe",
      "text":
          "This is a powerful post.asdasdasdasdasdasdasdasdasdasdsd Respect!",
      "replies": [
        {"author": "Ali", "text": "Totally agree!"},
        {"author": "Sara", "text": "Yes, very inspiring."}
      ]
    },
    {
      "author": "Emily",
      "text": "Praying for peace in Palestine 💔",
      "replies": []
    },
    {
      "author": "Michael",
      "text": "We need to raise awareness about this!",
      "replies": [
        {"author": "Yara", "text": "Start by sharing it!"}
      ]
    },
  ];
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAKvt_h7XNeQuygS26VtcqtMYhuOMRv8kgOwb9eKQYtdWyDXKCSCE_uo_FHSlQqiznAH-Pdw6YxiIA6Pw1iXaJj1-OMS3bxPgxkkpmcdCwgxbIIBSXB5osonvYf2ZQTqq4RunmRayPTzknDXaMPU5P3uvzvmEnXOsNqNbBGzabTaPXCZ3bB4fef1Jwiv0mkbPb9xZcri9NlYwRYHQSEGPRQeD5BTNNX_2lV_VL2UO-WuaKgdNuRPmZ7YYjI0_0PlqdZY_n4Omw-Dg0'),
                radius: 20,
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        comment.content,
                        maxLines: 3, // أو احذف maxLines لتُعرض كل السطور
                        softWrap: true,
                        overflow: TextOverflow.ellipsis, // أو TextOverflow.clip
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          if (comment.repliedBy.isNotEmpty) ...[
            // const Divider(height: 16),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: comment["replies"].map<Widget>((reply) {
            //     return Container(
            //       margin: const EdgeInsets.only(top: 6),
            //       padding: const EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         color: Colors.grey[100],
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Row(
            //         children: [
            //           const Icon(Icons.reply, size: 16, color: Colors.grey),
            //           const SizedBox(width: 6),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(reply["author"],
            //                     style: const TextStyle(
            //                         fontWeight: FontWeight.w600, fontSize: 13)),
            //                 Text(reply["text"],
            //                     style: const TextStyle(fontSize: 13)),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            // )
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostBloc>()
        ..add(const GetPostRequested("68696da0833b9926d5a1b346")),
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
                                context.read<PostBloc>().add(
                                    const GetPostRequested(
                                        "68696da0833b9926d5a1b346"));
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    );
                  } else if (state is PostdetailsLoaded) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(12),
                            children: [
                              // 🔷 Main Post Content
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(avatarUrl),
                                            radius: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  state.post.publisher.userName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[800])),
                                              Text(time,
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          const Spacer(),
                                          Icon(Icons.more_horiz,
                                              color: Colors.grey[500])
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(state.post.description,
                                          style: TextStyle(
                                              color: Colors.grey[700])),
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(imageUrl,
                                            height: 180, fit: BoxFit.cover),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                         LikeButtonWithCount(
                                        postId: "68696da0833b9926d5a1b346"),
                                              const SizedBox(width: 12),
                                              Icon(Icons.chat_bubble_outline,
                                                  size: 18,
                                                  color: Colors.grey[500]),
                                              const SizedBox(width: 4),
                                              Text(
                                                  state.post.comments.length
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
                              ...state.post.comments
                                  .map((c) => buildComment(c)),
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
                                          text, "68696da0833b9926d5a1b346"));
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
