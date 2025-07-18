// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/core/injection_container%20copy%202.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/components/buildComment.dart';

class Replyspage extends StatefulWidget {
  final List<String> commentsIds;
  final String postid;
  final Comment mainComment;

  const Replyspage({
    super.key,
    required this.commentsIds,
    required this.mainComment,
    required this.postid,
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
                      buildComment(
                        comment: widget.mainComment,
                        postid: widget.postid,
                      ),
                      const SizedBox(height: 2),
                      (state.replies != null)
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: state.replies!.length,
                                  itemBuilder: (context, index) {
                                    final comment = state.replies![index];
                                    return buildComment(
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
                                    AddCommentsRequested(text, widget.postid,
                                        widget.mainComment.id));

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
