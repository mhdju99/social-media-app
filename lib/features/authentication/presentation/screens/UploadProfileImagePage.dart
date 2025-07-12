import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/topicSelectionPage.dart';

class UploadProfileImagePage extends StatefulWidget {
  const UploadProfileImagePage({super.key});

  @override
  State<UploadProfileImagePage> createState() =>
      _ProfileImageSelectionScreenState();
}

class _ProfileImageSelectionScreenState extends State<UploadProfileImagePage> {
  File? selectedImage;

  Future<void> _pickImage(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
      context
          .read<AuthenticationBloc>()
          .add(UploadProfileImageRequested(file: File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationBloc>(),
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthImageUploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isUploading = state is AuthLoading;
          final isSuccess = state is AuthImageUploadSuccess;

          return Scaffold(
            appBar: AppBar(title: const Text("Profile Photo")),
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Choose a profile picture to complete your registration",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => _pickImage(context),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSuccess ? Colors.green : Colors.grey,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: selectedImage != null
                                    ? FileImage(selectedImage!)
                                    : const AssetImage(
                                            "assets/images/default_avatar.png")
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isUploading) const CircularProgressIndicator(),
                          if (isSuccess)
                            const Positioned(
                              bottom: 0,
                              child: Icon(Icons.check_circle,
                                  color: Colors.green, size: 40),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // const Spacer(),

                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            if (state is AuthImageUploadSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const topicSelectionPage()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state is AuthImageUploadSuccess
                                ? Colors.teal
                                : Colors.grey,
                            disabledBackgroundColor: Colors.teal.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text("Continue",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
