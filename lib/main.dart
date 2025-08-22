import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/cache/cache_helper.dart';
import 'package:social_media_app/core/injection_container%203.dart' as ch;
import 'package:social_media_app/core/injection_container%204.dart' as nt;
import 'package:social_media_app/core/injection_container%20copy%202.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/utils/logger.dart';
import 'package:social_media_app/core/utils/notifications_service.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/BlocObserver.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/splashScreen.dart';
import 'package:social_media_app/features/realtime/data/models/notification_model.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';

// ✅ متغيّر global
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Logger.log("App started");

  await init();
  await init2();
  await init3();
  await ch.init4();
  await nt.init5();
  await CacheHelper.init();
  await EndPoints.init();

  await NotificationService.init(); // ✅
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(
          create: (_) => ch.sl<ChatBloc>(),
        ),
        BlocProvider<TrackerBloc>(
          lazy: false,
          create: (_) {
            final bloc = ch.sl<TrackerBloc>();
            Future.microtask(() => bloc.add(ResetSessionEvent()));
            return bloc;
          },
        ),
        BlocProvider<AuthenticationBloc>(
          create: (_) => ch.sl<AuthenticationBloc>(),
        ),
        BlocProvider(
          create: (_) => nt.sl<NotificationBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // ✅ مهم جداً
      debugShowCheckedModeBanner: false,
      
      title: 'Neurest',
      theme: ThemeData(
         textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme, // ⬅️ كل النصوص تستخدم Poppins
        ),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
    );
  }
}
