import 'package:flutter/material.dart';

class blockUsersPage extends StatelessWidget {
  const blockUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> followers = [
      {
        "name": "أحمد علي",
        "imageUrl": "https://i.pravatar.cc/150?img=1",
        "isFollowing": false
      },
      {
        "name": "سارة محمود",
        "imageUrl": "https://i.pravatar.cc/150?img=2",
        "isFollowing": true
      },
      {
        "name": "خالد سامي",
        "imageUrl": "https://i.pravatar.cc/150?img=3",
        "isFollowing": false
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("blocked users")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: followers.length,
          separatorBuilder: (_, __) => const SizedBox(
            height: 5,
          ),
          itemBuilder: (context, index) {
            final user = followers[index];
            return Card(
              elevation: 2,
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    // فتح صفحة البروفايل الخاص بالمستخدم
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => UserProfilePage(userName: user["name"]),
                    //     ));
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user["imageUrl"]),
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    // نفس الشيء: فتح البروفايل
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => UserProfilePage(userName: user["name"]),
                    //     ));
                  },
                  child: Text(
                    user["name"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        user["isFollowing"] ? Colors.grey[200] : Colors.blue,
                    foregroundColor:
                        user["isFollowing"] ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(10, 36),
                  ),
                  onPressed: () {
                    // تغيير حالة المتابعة
                  },
                  child: Text(user["isFollowing"] ? "متابع" : "متابعة"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
