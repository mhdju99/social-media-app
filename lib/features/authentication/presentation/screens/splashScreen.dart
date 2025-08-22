import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
   SplashScreen({super.key});
  final List<String> backgrounds = [
    "assets/images/1.png",
    "assets/images/2.png",
    "assets/images/3.png",
    "assets/images/4.png",
    "assets/images/4.png",
    "assets/images/5.png",
    "assets/images/6.png",
    "assets/images/7.png",
    "assets/images/8.png",
    "assets/images/8.png",
    "assets/images/9.png",
    "assets/images/10.png",
    "assets/images/10.png",

  ];

  @override
  Widget build(BuildContext context) {
        final random = Random();
    final bgImage = backgrounds[random.nextInt(backgrounds.length)];
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
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                });
              } else if (state is AuthenticationInitial) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LogIn()),
                  );
                  ;
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
      backgroundColor: Colors.transparent,
  body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage),
            fit: BoxFit.cover,
          ),
        ),
        child:Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // أنيميشن احترافي للصورة مع زوايا منحنية
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: 1.0),
          duration: const Duration(milliseconds: 2000), // ⬅️ وقت أطول
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Transform.scale(
  scale: scale,
  child: Transform(
    transform: Matrix4.identity()
      ..setEntry(3, 2, 0.001) // عمق 3D
      ..rotateX(0.05) // ميل خفيف X
      ..rotateY(-0.05), // ميل خفيف Y
    alignment: FractionalOffset.center,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // لون الظل
            blurRadius: 18,  // مدى نعومة الظل
            offset: const Offset(0, 8), // اتجاه الظل لأسفل
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          'assets/icon.png',
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    ),
  ),
)
,
            );
          },
        ),
        const SizedBox(height: 15),
        // Fade + Slide للنص
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 2500), // ⬅️ وقت أطول
          curve: Curves.easeOutCubic,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 40 * (1 - opacity)), // ⬅️ حركة أطول
                child:  Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001) // عمق 3D
    ..rotateX(0.01)           // ميل خفيف X
    ..rotateY(-0.01),         // ميل خفيف Y
  alignment: FractionalOffset.center,
  child: Text(
    "Neurest",
    style: GoogleFonts.poppins( // أو أي خط يناسب شعارك
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 2,
      color: Colors.grey.shade900,
      shadows: [
        Shadow(
          offset: Offset(0, 4),       // اتجاه الظل
          blurRadius: 15,             // نعومة الظل
          color: Colors.grey.withOpacity(0.35), // لون الظل
        ),
        Shadow(
          offset: Offset(0, 2),
          blurRadius: 5,
          color: Colors.blueGrey.withOpacity(0.2),
        ),
      ],
    ),
  ),
)
,
              ),
            );
          },
        ),
      ],
    ),
  )) ,
)

,
      ),
    );
  }
}
