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
              if (state is checkLoginSuccess) {
                context.read<ChatBloc>().add(ConnectToSocketEvent());

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              } else if (state is AuthenticationInitial) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LogIn()),
                );
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
        child: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
