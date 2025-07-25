import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/cache/cache_helper.dart';
import 'package:social_media_app/core/injection_container%203.dart' as ch;
import 'package:social_media_app/core/injection_container%204.dart' as nt;
import 'package:social_media_app/core/injection_container%20copy%202.dart';
import 'package:social_media_app/core/injection_container%20copy.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/injection_container.dart' as NotificationService;
import 'package:social_media_app/core/utils/logger.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/BlocObserver.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/splashScreen.dart';
import 'package:social_media_app/features/realtime/data/models/notification_model.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  await Logger.clear();
    
    //  Logger.testReadLogs(); // إضافة هنا

  await Logger.log("App started");
  // Bloc.observer = SimpleBlocObserver();
  
  await init();
  await init2();
  await init3();
  await ch.init4();
  await nt.init5();
  await CacheHelper.init();
    await EndPoints.init();

  await NotificationService.init();
   await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());
  runApp(
    MultiBlocProvider(
      providers: [
          
        BlocProvider<ChatBloc>(
          create: (_) => ch.sl<ChatBloc>(),
        ),
         BlocProvider<TrackerBloc>(
            lazy: false, // هذا يُجبره على الإنشاء حتى لو لم يُستخدم

  create: (_) {
    
    final bloc = ch.sl<TrackerBloc>();
    Future.microtask(() => bloc.add(ResetSessionEvent())); // هنا الفرق
    return bloc;
  },
),
          BlocProvider<AuthenticationBloc>(
          create: (_) => ch.sl<AuthenticationBloc>(),
        ),
         BlocProvider(
          create: (_) => nt.sl<NotificationBloc>(),
        ),
        // BlocProvider<AnotherBloc>(create: (_) => sl<AnotherBloc>()..add(...))
        // أضف هنا أي Bloc آخر تستخدمه
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
     
        // tested with just a hot reload.
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
