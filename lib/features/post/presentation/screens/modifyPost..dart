import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';
import 'package:social_media_app/features/post/domian/usecases/create_post.dart';
import 'dart:io';

import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';

class ModifyPostPage extends StatefulWidget {
  final PostDetails post;
  const ModifyPostPage({super.key, required this.post});

  @override
  _ModifyPostPageState createState() => _ModifyPostPageState();
}

class _ModifyPostPageState extends State<ModifyPostPage> {
  final TextEditingController _postController = TextEditingController();
  List<File> _images = [];
  List<String> imagesNetwork = [];
  List<String> imagesdeleted = [];

  @override
  void initState() {
    super.initState();
    _postController.text = widget.post.description;
    imagesNetwork = widget.post.images;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
     XFile? picked;

    
    if (_images.length + imagesNetwork.length < 4) {
      picked = await picker.pickImage(source: ImageSource.gallery);
    }
    if (picked != null) {
      setState(() {
        _images.add(File(picked!.path));
      });
    }
  }
  

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _removeImageNetwork(int index) {
    setState(() {
      imagesdeleted.add(imagesNetwork[index]);

      imagesNetwork.removeAt(index);
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
                content: const Text("The post has been updated"),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(16),
              ),
            );
            Navigator.pop(context, 'refresh'); // إغلاق الـ BottomSheet
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
            ));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Modify Post'),
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
                widget.post.images.isEmpty
                    ? const Text('No images added yet.')
                    : SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.post.images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: Image.network(
                                                "${EndPoints.baseUrl}/posts/get-file?filesName=${widget.post.images[index]}&postId=${widget.post.id}")
                                            .image,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () => _removeImageNetwork(index),
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
                        print(imagesdeleted);
                        context.read<PostBloc>().add(ModifyPostRequested(
                              postId: widget.post.id,
                              newDescription: _postController.text,
                              newImages: _images,
                              imagesToDelete: imagesdeleted,
                            ));
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
