import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/notifications_service.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_state.dart';
import 'package:social_media_app/features/realtime/presentation/screens/allchatsPage.dart';
import 'package:social_media_app/features/realtime/presentation/screens/chatPage.dart';
import 'package:social_media_app/features/post/presentation/screens/homePage.dart';
import 'package:social_media_app/features/post/presentation/screens/rellsPage.dart';
import 'package:social_media_app/features/profile/presentation/screens/myProfailPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  Key _chatsKey = UniqueKey();
  Key _profileKey = UniqueKey();
  final List<Widget> _staticPages = [
    const Homepage(),
    const RellsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      _chatsKey = UniqueKey();
    } else if (index == 3) {
      _profileKey = UniqueKey();
    }
  }

  @override
  void initState() {
    super.initState();

    final notificationBloc = context.read<NotificationBloc>();

    // لا حاجة للاشتراك هنا إن كنت قد فعلت stream.listen داخل Bloc نفسه
    // فقط إذا أردت logging إضافي مثلاً
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationUpdated) {
          print(state.notifications[0]);

          NotificationService.showNotification(
            title: 'New Notification',
            body: state.notifications[0]["text"],
          );
          context
              .read<NotificationBloc>()
              .add(AddNotificationEvent(state.notifications[0]));
          // for (var notification in state.notifications) {
          //   print(notification);
          //               print(">💨");

          //   NotificationService.showNotification(
          //     title: 'New Notification',
          //     body: notification["text"],
          //   );
          //   context
          //       .read<NotificationBloc>()
          //       .add(AddNotificationEvent(notification));
          // }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _staticPages[0],
            _staticPages[1],
            ChatsPage(
              key: _chatsKey,
            ),
            ProfileScreen(
              key: _profileKey,
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: BottomNavigationBar(
              iconSize: 30,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedFontSize: 1,
              type: BottomNavigationBarType.fixed,
              selectedIconTheme: const IconThemeData(size: 30),
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey.shade600,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.explore), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
