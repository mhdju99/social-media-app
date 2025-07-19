import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_state.dart';
import '../../../../core/injection_container 3.dart';

class ChatPage extends StatefulWidget {
  final String targetUserId;

  const ChatPage({
    super.key,
    required this.targetUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom1();
    });
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
              ),
            ),
            child: Text(message,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _botMessage(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.support_agent, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
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
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(GetChatEvent(widget.targetUserId)),
      child: Scaffold(
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
                  state.chat.messages.forEach((msg) {
                    messages.add({
                      'from': msg.from,
                      'to': msg.to,
                      'content': msg.content,
                      'createdAt': msg.createdAt,
                    });
                  });
                });
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
                      const Icon(Icons.arrow_back_ios, color: Colors.black),
                      const Text("Chat",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Icon(Icons.search, color: Colors.black),
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
                    border:
                        Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Type your message here...",
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
      ),
    );
  }
}
