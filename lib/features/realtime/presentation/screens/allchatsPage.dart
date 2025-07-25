import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/domain/usecases/GetUserProfileUsecase.dart';
import 'package:social_media_app/features/realtime/domain/entities/chat_entity.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_state.dart';
import 'package:social_media_app/features/realtime/presentation/screens/chatPage.dart';

import '../../../../core/injection_container 3.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<ChatEntity>? chats;
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetAllChatEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatMessageReceived) {
          context.read<ChatBloc>().add(GetAllChatEvent());

          // if (chats != null) {
          //   int index = chats!.indexWhere(
          //       (chat) => chat.messages.first.from == state.message['from']);

          //   if (index != -1) {
          //              chats![index].messages.add(MessageEntity(
          //         from: state.message['from'],
          //         to: state.message['to'],
          //         content: state.message['content'],
          //         createdAt: DateTime.parse(state.message['createdAt'])));
          //   }
          // }

          // if (state.message['from'] == widget.targetUserId) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     _scrollToBottom();
          //   });
          //   print("object");
          //   print(state.message);
          //   setState(() {
          //     messages.add(state.message);
          //   });
          // }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Chats',
            style: TextStyle(color: Colors.grey[800]),
          ),
          actions: [
            InkWell(
                onTap: () {
                  context.read<ChatBloc>().add(GetAllChatEvent());
                },
                child: const Icon(Icons.refresh, color: Colors.black)),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatListLoaded) {
              chats = state.chats;
              if (chats != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ChatBloc>().add(GetAllChatEvent());
                    },
                    child: ListView.builder(
                      itemCount: chats!.length,
                      itemBuilder: (context, index) {
                        final chat = chats![index];
                        final lastMessage;
                        if ( chat.messages.isNotEmpty) {
                          lastMessage = chat.messages.last;
                        } else {
                          lastMessage = MessageEntity;
                        }

                        final targetUserId = chat.users.first;

                        return FutureBuilder<Either<Failure, UserProfile>>(
                          future:
                              sl<GetUserProfileUsecase>().call(targetUserId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const ListTile(title: Text("Loading..."));
                            }

                            final result = snapshot.data!;

                            return result.fold(
                              (failure) => const ListTile(
                                title: Text("Failed to load user data"),
                              ),
                              (user) => Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${user.profileImage}",
                                    ),
                                    radius: 20,
                                  ),
                                  title: Text(user.userName),
                                  subtitle: Text(chat.messages.isNotEmpty?lastMessage.content:''),
                                  trailing: chat.messages.isNotEmpty? Text(
                                   formatchatDate(
                                        lastMessage.createdAt.toString()),
                                    style: const TextStyle(fontSize: 12),
                                  // ignore: prefer_const_constructors
                                  ):Icon(Icons.chat,
                                  size: 25,
                                  color: Colors.green,
                                  ),
                                  onTap: () {
                                    final chatBloc = context.read<
                                        ChatBloc>(); // ✅ خزّن المرجع قبل التنقل

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatPage(
                                          targetUserId: targetUserId,
                                          user: user,
                                        ),
                                      ),
                                    ).then((_) {
                                      // ✅ ينفذ بعد الرجوع من ChatPage
                                      chatBloc.add(
                                          GetAllChatEvent()); // أو أي حدث BLoC آخر
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }
            } else if (state is ChatError) {
              return Center(
                  child: Column(
                children: [
                  const Text("Failed to load chats"),
                  InkWell(
                      onTap: () {
                        context.read<ChatBloc>().add(GetAllChatEvent());
                      },
                      child: const Icon(Icons.refresh, color: Colors.black))
                ],
              ));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
