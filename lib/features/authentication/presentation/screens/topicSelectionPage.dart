import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/testPage.dart';
import 'package:social_media_app/features/post/presentation/screens/homePage.dart';
import 'package:social_media_app/main_page.dart';
// import '../bloc/genre_bloc.dart';

class topicSelectionPage extends StatefulWidget {
  const topicSelectionPage({super.key});

  @override
  State<topicSelectionPage> createState() => _topicSelectionPageState();
}

class _topicSelectionPageState extends State<topicSelectionPage> {
  final List<String> topics = [
    "Anxiety & Stress Management",
    "Depression & Mood Disorders",
    "Relationships & Interpersonal Issues",
    "Self-Esteem & Identity",
    "Trauma & PTSD",
    "Growth, Healing & Motivation",
  ];

  List<String> selectedTopic = [];

  void toggleSelection(String topic) {
    setState(() {
      if (selectedTopic.contains(topic)) {
        selectedTopic.remove(topic);
      } else {
        selectedTopic.add(topic);
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Select preferred Topics')),
        body: BlocProvider(
          create: (context) => sl<AuthenticationBloc>(),
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is ChosePreferredTopicsSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...List.generate(
                        topics.length,
                        (index) => GestureDetector(
                          onTap: () {
                            toggleSelection(topics[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedTopic.contains(topics[index])
                                      ? Colors.teal
                                      : Colors.grey.shade600),
                              color: selectedTopic.contains(topics[index])
                                  ? Colors.teal
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(topics[index],
                                style: TextStyle(
                                    fontSize: 13,
                                    color: selectedTopic.contains(topics[index])
                                        ? Colors.white
                                        : Colors.grey.shade600)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            print(selectedTopic);
                            context.read<AuthenticationBloc>().add(
                                ChosePreferredTopicsRequested(
                                    topic: selectedTopic.join('_')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedTopic.length >= 2
                                ? Colors.teal
                                : Colors.grey,
                            disabledBackgroundColor: Colors.teal.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Next",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                          // state is GenreSubmitting
                          //     ? CircularProgressIndicator(color: Colors.white)
                          //     : Text("Next"),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
