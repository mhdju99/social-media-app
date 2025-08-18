import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/utils/notifications_service.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/topicSelectionPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/UploadProfileImagePage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/logInPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/testPage.dart';
import 'package:social_media_app/features/post/presentation/screens/createPost.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_state.dart';
import 'package:social_media_app/features/realtime/presentation/screens/chatPage.dart';
import 'package:social_media_app/main_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<AuthenticationBloc>()..add(CheckAuthStateRequested()),
        ),
        // BlocProvider(
        //   create: (context) => sl<ChatBloc>(),
        // ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              Duration delay = const Duration(seconds: 3); // مدة التأخير

              if (state is checkLoginSuccess) {
                context.read<ChatBloc>().add(ConnectToSocketEvent());
                Future.delayed(const Duration(seconds: 4), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                });
              } else if (state is AuthenticationInitial) {
                   Future.delayed(const Duration(seconds: 4), () {
                     Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LogIn()),
                );;
                });
             
              }
            },
          ),
          BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NotificationUpdated) {
                for (var notification in state.notifications) {
                  NotificationService.showNotification(
                    title: 'New Notification',
                    body: notification["text"],
                  );
                }
              }
            },
          )

          // BlocListener<ChatBloc, ChatState>(listener: (context, state) {
          //   // أضف هنا أي رد فعل على تغييرات ChatBloc إن أردت
          // }),
        ],
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أنيميشن بسيط للشعار (تكبير/تصغير)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.7, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Image.asset(
                        'assets/icon.png', // أيقونتك
                        width: 100,
                        height: 100,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Fade in للنص
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: const Text(
                        "Neurest",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
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
