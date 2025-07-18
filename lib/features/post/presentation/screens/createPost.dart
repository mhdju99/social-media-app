import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/features/post/domian/usecases/create_post.dart';
import 'dart:io';

import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
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
  final List<File> _mediaFiles = [];

  final List<String> _topics = [
    "Anxiety & Stress Management",
    "Depression & Mood Disorders",
    "Relationships & Interpersonal Issues",
    "Self-Esteem & Identity",
    "Trauma & PTSD",
    "Growth, Healing & Motivation",
  ];
  late String _selectedTopic = "";
  String _postType = 'Post'; // or 'Reels'

  Future<void> _pickMedia() async {
    final picker = ImagePicker();

    if (_postType == 'Reels') {
      final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        setState(() {
          _mediaFiles
            ..clear()
            ..add(File(pickedVideo.path));
        });
      }
    } else {
      if (_mediaFiles.length >= 4) return;

      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _mediaFiles.add(File(pickedImage.path));
        });
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
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
              const SnackBar(
                content: Text("The post has been created"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          } else if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
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
                // Post Type Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['Post', 'Reels'].map((type) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: _postType == type,
                        onSelected: (_) {
                          setState(() {
                            _postType = type;
                            _mediaFiles
                                .clear(); // clear media when type changes
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Description
                TextField(
                  controller: _postController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Write something...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Topic Selector
                const Text('Select Post Topic:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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

                // Media Preview
                Text(
                  _postType == 'Reels' ? 'Attached Video:' : 'Attached Images:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _mediaFiles.isEmpty
                    ? const Text('No media added yet.')
                    : SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _mediaFiles.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _postType == 'Reels'
                                        ? const Icon(Icons.videocam, size: 100)
                                        : Image.file(
                                            _mediaFiles[index],
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
                                    onTap: () => _removeMedia(index),
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

                // Add Media Button
                ElevatedButton.icon(
                  onPressed: _postType == 'Post' && _mediaFiles.length >= 4
                      ? null
                      : _pickMedia,
                  icon: Icon(
                      _postType == 'Reels' ? Icons.video_library : Icons.image),
                  label: Text(_postType == 'Reels' ? 'Add Video' : 'Add Image'),
                ),
                const SizedBox(height: 16),

                // Submit Button
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<PostBloc>().add(
                              CreatePostRequested(
                                topic: _selectedTopic,
                                description: _postController.text,
                                images: _mediaFiles,
                                reelFlag: _postType == 'Reels',
                              ),
                            );
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
