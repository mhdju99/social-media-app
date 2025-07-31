import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/UserActions%20.dart';
import 'package:social_media_app/core/constants/category.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/post/domian/entities/comment_entity.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/post/presentation/screens/replysPage.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';

class buildComment extends StatefulWidget {
  final Comment comment;
  final String postid;
  final String topic;

  const buildComment(
      {super.key,
      required this.comment,
      required this.postid,
      required this.topic});

  @override
  State<buildComment> createState() => _buildCommentState();
}

class _buildCommentState extends State<buildComment> {
  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    return Padding(
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
                    backgroundImage: (comment.user.profileImage.isNotEmpty)
                        ? NetworkImage(
                            "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${comment.user.profileImage}",
                          )
                        : const AssetImage("assets/images/default_avatar.png"),
                    radius: 20,
                  ),
                  Visibility(
                    visible: widget.comment.repliedBy.isNotEmpty,
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
                    InkWell(
                      onLongPress: () {
                        if (comment.isMyComment!) {
                          return _showPostOptions(context, comment.id);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // color:true? Colors.grey[300]: Colors.grey[400],
                          color: comment.isMyComment!
                              ? Colors.grey[350]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment.user.userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(formatPostTime(widget.comment.createdAt),
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 12))
                              ],
                            ),
                            Text(
                              comment.content,
                              maxLines: 3, // أو احذف maxLines لتُعرض كل السطور
                              softWrap: true,
                              overflow:
                                  TextOverflow.ellipsis, // أو TextOverflow.clip
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 7,
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<PostBloc>()
                                .add(LikeCommentEvent(commentId: comment.id));
                          },
                          child: Icon(
                            comment.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color:
                                comment.isLiked ? Colors.red : Colors.grey[500],
                          ),
                        ),
                        Text(comment.likesCount !=0?comment.likesCount.toString():'',
                            style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Replyspage(
                                        topic: widget.topic,
                                        postid: widget.postid,
                                        mainComment: comment.copyWith(
                                          repliedBy: [],
                                        ),
                                        commentsIds:
                                            (comment.repliedBy.isNotEmpty)
                                                ? [comment.id]
                                                : [],
                                      )),
                            );
                          },
                          child: Icon(Icons.reply_outlined,
                              size: 18, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 4),
                        const SizedBox(width: 12),
                      ],
                    ),
                    Visibility(
                      visible: comment.repliedBy.isNotEmpty,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Replyspage(
                                      topic: widget.topic,
                                      postid: widget.postid,
                                      mainComment: comment.copyWith(
                                        repliedBy: [],
                                      ),
                                      commentsIds: [comment.id],
                                    )),
                          );
                        },
                        child: Text(
                          "see ${comment.repliedBy.length} more replies",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
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
    );
  }
}

void _showPostOptions(BuildContext contexta, String id) {
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
                leading:
                    const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: const Text(
                  "Delete",
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context); // إغلاق الـ BottomSheet

                  contexta
                      .read<PostBloc>()
                      .add(DeleteCommentEvent(commentId: id));
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
