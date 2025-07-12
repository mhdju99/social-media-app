import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/features/post/domian/usecases/create_post.dart';
import 'dart:io';

import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  final List<File> _images = [];

  final List<String> _topics = [
    "Anxiety & Stress Management",
    "Depression & Mood Disorders",
    "Relationships & Interpersonal Issues",
    "Self-Esteem & Identity",
    "Trauma & PTSD",
    "Growth, Healing & Motivation",
  ];
  late String _selectedTopic = "";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _images.add(File(picked.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostBloc>(),
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 4,
                content: const Text("The post has been created"),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(16),
              ),
            );
          } else if (state is PostError) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              elevation: 4,
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(16),
            ))
            ;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                TextField(
                  controller: _postController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Write something...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Post Topic:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8.0,
                    children: _topics.map((topic) {
                      return ChoiceChip(
                        label: Text(topic),
                        selected: _selectedTopic == topic,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTopic = topic;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Attached Images:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _images.isEmpty
                    ? const Text('No images added yet.')
                    : SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _images[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close,
                                          size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Add Image'),
                ),
                const SizedBox(height: 16),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<PostBloc>().add(CreatePostRequested(
                            topic: _selectedTopic,
                            description: _postController.text,
                            images: _images,
                            reelFlag: false));
                      },
                      child: state is PostLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Post'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
