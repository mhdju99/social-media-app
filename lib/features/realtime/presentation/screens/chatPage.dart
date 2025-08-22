import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/presentation/screens/userProfailPage.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_user_online_status_usecase.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_state.dart';
import '../../../../core/injection_container 3.dart';

class ChatPage extends StatefulWidget {
  final UserProfile user;
  final String targetUserId;

  const ChatPage({
    super.key,
    required this.targetUserId,
    required this.user,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool? isOnline;
  String? lastSeenAt;

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // _scrollController = ScrollController();
    _fetchStatus();
    // BlocProvider<ChatBloc>(
    //   create: (_) => sl<ChatBloc>()..add(GetChatEvent(widget.targetUserId)),
    // );
    context.read<ChatBloc>().add(GetChatEvent(widget.targetUserId));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom1();
    });
  }

  Future<void> _fetchStatus() async {
    final result =
        await sl<GetUserOnlineStatusUseCase>().call(widget.targetUserId);
    result.fold(
      (failure) => setState(() => isOnline = null), // أو null
      (status) => setState(() {
        isOnline = status["onlineFlag"];
        lastSeenAt = status["lastSeenAt"] != null
            ? DateTime.parse(status["lastSeenAt"]).toLocal().toString()
            : null;
      }),
    );
  }

  void _scrollToBottom1() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Stream<DateTime> get _timeStream => Stream<DateTime>.periodic(
      const Duration(minutes: 1), (_) => DateTime.now());

  final TextEditingController _messageController = TextEditingController();
  List<Map<dynamic, dynamic>> messages = [];

  // نفترض أن معرف المستخدم الحالي هو "myUserId"
  final String myUserId = "0"; // ← غيّره بحسب نظامك

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now().toIso8601String();

    // أرسل الحدث إلى bloc
    context.read<ChatBloc>().add(SendMessageEvent(widget.targetUserId, text));

    // أضف الرسالة محلياً (لإظهارها فوراً في الواجهة)
    final message = {
      "from": myUserId,
      "to": widget.targetUserId,
      "content": text,
      "createdAt": now,
    };
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    setState(() {
      messages.add(message);
      _messageController.clear();
    });
  }

  Widget _userMessage(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                // bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(message,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ),
        const SizedBox(width: 8),
        // const CircleAvatar(
        //   backgroundColor: Colors.teal,
        //   child: Icon(Icons.person, color: Colors.white),
        // ),
      ],
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _botMessage(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CircleAvatar(
        //   backgroundColor: Colors.grey[300],
        //   child: const Icon(Icons.support_agent, color: Colors.grey),
        // ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                // bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(message, style: const TextStyle(fontSize: 14)),
          ),
        ),
      ],
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // تحميل المحادثة عند الدخول
  //   context.read<ChatBloc>().add(GetChatEvent(widget.targetUserId));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatMessageReceived) {
              if (state.message['from'] == widget.targetUserId) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
                print("object");
                print(state.message);
                setState(() {
                  messages.add(state.message);
                });
              }
            } else if (state is ChatLoaded) {
              setState(() {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom1();
                });
                for (var msg in state.chat.messages) {
                  messages.add({
                    'from': msg.from,
                    'to': msg.to,
                    'content': msg.content,
                    'createdAt': msg.createdAt,
                  });
                }
              });
            } else if (state is UserBecameOnlineState) {
              print("💕${widget.targetUserId} on;ine");
              if (state.userId == widget.targetUserId) {
                setState(() {
                  isOnline = true;
                });
              }
            } else if (state is UserBecameOfflineState) {
                            print("💕${widget.targetUserId} offlinne");

              if (state.userId == widget.targetUserId) {
                setState(() {
                  lastSeenAt = DateTime.now().toIso8601String();
                  isOnline = false;
                });
              }
            }
          },
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UserProfileScreen(userId: widget.targetUserId)),
                        );
                          },
                          child: Text(
                              "${capitalize(widget.user.firstName)} ${capitalize(widget.user.lastName)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        if (isOnline != null)
                          if (lastSeenAt != null && !isOnline!)
                            StreamBuilder<DateTime>(
                              stream: _timeStream,
                              initialData:
                                  DateTime.now(), // عرض أولي لحين أول تحديث
                              builder: (context, snapshot) {
                                final currentTime =
                                    snapshot.data ?? DateTime.now();
                                final lastSeen = DateTime.parse(lastSeenAt!)
                                    .toLocal(); // أو متغيرك المحول من السيرفر
                                return Text(
                                    formatPostTime(lastSeen, now: currentTime),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey));
                              },
                            )
                      ],
                    ),
                    OnlineStatusDot(isOnline: isOnline),
                  ],
                ),
              ),
              // Messages
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['from'] != widget.targetUserId;

                    if (isMe) {
                      return _userMessage(msg['content']);
                    } else {
                      return _botMessage(msg['content']);
                    }
                  },
                ),
              ),
              // Input
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Message",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnlineStatusDot extends StatefulWidget {
  final bool? isOnline;

  const OnlineStatusDot({super.key, required this.isOnline});

  @override
  State<OnlineStatusDot> createState() => _OnlineStatusDotState();
}

class _OnlineStatusDotState extends State<OnlineStatusDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 0.3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = widget.isOnline;

    if (isOnline != true) {
      // لا يوجد وميض، فقط نقطة ثابتة حمراء أو بيضاء
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isOnline == false ? Colors.red : Colors.white,
          border: Border.all(color: Colors.white, width: 2),
        ),
      );
    }

    // حالة online = true → وميض أخضر
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
