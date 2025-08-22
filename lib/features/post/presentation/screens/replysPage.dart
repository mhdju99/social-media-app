// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/UserActions%20.dart';
import 'package:social_media_app/core/constants/category.dart';
import 'package:social_media_app/core/constants/end_points.dart';

import 'package:social_media_app/core/injection_container%20copy%202.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/components/buildComment.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';

class Replyspage extends StatefulWidget {
  final List<String> commentsIds;
  final String postid;
  final String topic;
  final Comment mainComment;

  const Replyspage({
    super.key,
    required this.commentsIds,
    required this.mainComment,
    required this.postid,
    required this.topic,
  });

  @override
  State<Replyspage> createState() => _ReplyspageState();
}

class _ReplyspageState extends State<Replyspage> {
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

  void _showcommwntOptions(
    BuildContext contexta,
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
                  leading: const Icon(Icons.person_off, color: Colors.black),
                  title: const Text(
                    "add anonymous comment",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () async {
                    final text = commentController.text;
                    if (text.trim().isEmpty) return;

                    setState(() => isSubmitting = true);

                    // هنا يمكن إضافة حدث إضافة تعليق للبلوك لو كان جاهز
                    contexta.read<PostBloc>().add(AddCommentsRequested(
                        comments: text,
                        postId: widget.postid,
                        replyto: widget.mainComment.id,
                        hiddenflag: true));
                    context.read<TrackerBloc>().add(LogActionEvent(
                        category: category[widget.topic]!,
                        action: UserActions.comment));
                    commentController.clear();
                    await Future.delayed(const Duration(milliseconds: 500));

                    setState(() => isSubmitting = false);
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _scrollToBottom());
                    Navigator.pop(
                      context,
                    );
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
      create: (context) =>
          sl<PostBloc>()..add(GetRepliesEvent(commentsIds: widget.commentsIds)),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Replys"),
              backgroundColor: Colors.white,
            ),
            body: () {
              if (state is CommentLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CommentFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.error),
                      IconButton(
                        onPressed: () {
                          context.read<PostBloc>().add(
                              GetRepliesEvent(commentsIds: widget.commentsIds));
                        },
                        icon: const Icon(Icons.refresh),
                      )
                    ],
                  ),
                );
              } else if (state is RepliesLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: (widget
                                                  .mainComment.hiddenFlag ==
                                              false)
                                          ? (widget.mainComment.user
                                                  .profileImage.isNotEmpty)
                                              ? NetworkImage(
                                                  "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${widget.mainComment.user.profileImage}",
                                                )
                                              : const AssetImage(
                                                  "assets/images/default_avatar.png")
                                          : const AssetImage(
                                              "assets/images/anonymous-user.png"),

                                      // backgroundImage: (!comment.hiddenFlag)?: AssetImage("assets/images/anonymous-user.png"),
                                      radius: 20,
                                    ),
                                    Visibility(
                                      visible: widget
                                          .mainComment.repliedBy.isNotEmpty,
                                      child: Container(
                                        width: 2,
                                        height: 60, // حسب المحتوى
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          // color:true? Colors.grey[300]: Colors.grey[400],
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  (widget.mainComment
                                                              .hiddenFlag ==
                                                          true)
                                                      ? "Anonymous user"
                                                      : widget.mainComment.user
                                                          .userName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    formatPostTime(widget
                                                        .mainComment.createdAt),
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 12))
                                              ],
                                            ),
                                            Text(
                                              widget.mainComment.content,
                                              maxLines:
                                                  3, // أو احذف maxLines لتُعرض كل السطور
                                              softWrap: true,
                                              overflow: TextOverflow
                                                  .ellipsis, // أو TextOverflow.clip
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            // Align(
                            //   alignment: Alignment.center,
                            //   child: SizedBox(
                            //     width: MediaQuery.of(context).size.width * 0.8, // 80% من العرض
                            //     child: Divider(
                            //       thickness: 1,
                            //       color: Colors.grey[300],
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      )
                      // buildComment(
                      //   comment: widget.mainComment,
                      //   postid: widget.postid,
                      //   topic: widget.topic,
                      // ),
                      ,
                      const SizedBox(height: 2),
                      (state.replies != null)
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: state.replies!.length,
                                  itemBuilder: (context, index) {
                                    final comment = state.replies![index];
                                    return buildComment(
                                      topic: widget.topic,
                                      comment: comment,
                                      postid: widget.postid,
                                    );
                                  },
                                ),
                              ),
                            )
                          : const Expanded(
                              child: SizedBox(
                              height: double.infinity,
                            )),
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
                              onLongPress: () {
                                return _showcommwntOptions(context);
                              },
                              icon: isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Icons.send, color: Colors.blue),
                              onPressed: () async {
                                final text = commentController.text;
                                if (text.trim().isEmpty) return;

                                setState(() => isSubmitting = true);

                                // هنا يمكن إضافة حدث إضافة تعليق للبلوك لو كان جاهز
                                context.read<PostBloc>().add(
                                    AddCommentsRequested(
                                        comments: text,
                                        postId: widget.postid,
                                        replyto: widget.mainComment.id,
                                        hiddenflag: false));
                                context.read<TrackerBloc>().add(LogActionEvent(
                                    category: category[widget.topic]!,
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
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }(),
          );
        },
      ),
    );
  }
}
