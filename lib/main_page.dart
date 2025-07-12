import 'package:flutter/material.dart';
import 'package:social_media_app/chatPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/UploadProfileImagePage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/testPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/topicSelectionPage.dart';
import 'package:social_media_app/features/post/presentation/screens/homePage.dart';
import 'package:social_media_app/features/profile/presentation/screens/myProfailPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const testpage(), // الصفحة الرئيسية للمنشورات
    const ChatPage1(), // صفحة المحادثة مع OpenAI
    ProfileScreen(), // صفحة الاستخدام
    // ProfilePage(), // الصفحة الشخصية أو الإعدادات
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24))),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: BottomNavigationBar(
            showSelectedLabels: false, // ⛔️ إخفاء العنوان المحدد
            showUnselectedLabels: false, // ⛔️ إخفاء العنوان غير المحدد
            selectedFontSize: 1,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: const IconThemeData(size: 30),
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey.shade600,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 30,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.explore,
                    size: 30,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    size: 30,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  label: ""),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              _onItemTapped(index);
            },
          ),
        ),
      ),
    );
  }
}

// BottomNavigationBar(
//         selectedFontSize: 14,
//         type: BottomNavigationBarType.shifting,
//         selectedIconTheme: const IconThemeData(size: 19),
//         showUnselectedLabels: true,
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey.shade600,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home_outlined,
//                 size: 30,
//               ),
//               label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.explore,
//                 size: 30,
//               ),
//               label: "Discover"),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.chat,
//                 size: 30,
//               ),
//               label: "Chat"),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.person,
//                 size: 30,
//               ),
//               label: "Profile"),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           _onItemTapped(index);
//         },
//       )
