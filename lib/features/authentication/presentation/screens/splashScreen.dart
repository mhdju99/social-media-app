import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/topicSelectionPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/UploadProfileImagePage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/logInPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/testPage.dart';
import 'package:social_media_app/features/post/presentation/screens/createPost.dart';
import 'package:social_media_app/main_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AuthenticationBloc>()..add(CheckAuthStateRequested()),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is checkLoginSuccess) {
            print("object");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
              // MaterialPageRoute(builder: (context) => MainPage()),
            );
          } else if (state is AuthenticationInitial) {
            print("object");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LogIn()),
            );
          }
        },
        child: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
