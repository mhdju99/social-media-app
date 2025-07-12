import 'package:flutter/material.dart';

class ChatPage1 extends StatelessWidget {
  const ChatPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.grey[700]),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text("Dr. Nightingale AI",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F8),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text("GPT-7",
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF374151))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text("251 Chats left this month",
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _userMessage("Hello, Who are you? My name is Holo."),
                  const SizedBox(height: 8),
                  _botMessage([
                    "Greetings, Holo! I am Dr. Nightingale AI, and I'm here to assist you with your medical & healthcare needs. 🫡",
                    "If you need any medical inquiries regarding your health, do let me know! 🥰",
                  ]),
                  const SizedBox(height: 16),
                  _centeredTime("Today at 09:12 AM"),
                  const SizedBox(height: 16),
                  _userMessage(
                      "Yo that's Awesome! Anyway, I have small nausea and flu lately, do you have suggestions to help me feel better? 😬"),
                  const SizedBox(height: 8),
                  _typingIndicator(),
                ],
              ),
            ),
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        CircleAvatar(
          backgroundColor: Colors.teal,
          child: const Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _botMessage(List<String> messages) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messages
                  .map((msg) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(msg, style: const TextStyle(fontSize: 14)),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _centeredTime(String time) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(time,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }

  Widget _typingIndicator() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.support_agent, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Dr. Nightingale is thinking...",
                  style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Row(
                children: const [
                  _Dot(delay: Duration(milliseconds: 0)),
                  _Dot(delay: Duration(milliseconds: 150)),
                  _Dot(delay: Duration(milliseconds: 300)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatefulWidget {
  final Duration delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.teal,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
