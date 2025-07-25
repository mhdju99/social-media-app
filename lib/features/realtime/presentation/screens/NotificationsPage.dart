import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container 4.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/realtime/domain/usecases/mark_as_read.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_event.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_state.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotificationsEvent());
  }

  void markAllNotificationsAsRead() async {
    // استدع الدالة التي تحدث الحفظ محليًا
    await sl<MarkAsReadUseCase>().call();

    // إذا كنت تستخدم BLoC وتحتاج لتحديث الواجهة تلقائيًا:
    // if (mounted) {
    //   context.read<NotificationBloc>().add(LoadNotificationsEvent());
    // }
  }

  @override
  void dispose() {
    // اجعل كل الإشعارات مقروءة عند مغادرة الصفحة
    markAllNotificationsAsRead();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Notifications',
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.settings, color: Colors.grey),
            )
          ],
        ),
        body: Column(
          children: [
            _filterButtons(),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is Notificationloading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationLoaded) {
                    List<NotificationEntity> notifications =
                        state.notifications;

                    // ✅ Apply local UI filter
                    if (selectedFilterIndex == 1) {
                      notifications =
                          notifications.where((n) => !n.isRead).toList();
                    }

                    if (notifications.isEmpty) {
                      return const Center(child: Text("No notifications yet."));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _notificationTile(notification);
                      },
                    );
                  } else {
                    return const Center(child: Text("Something went wrong."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButtons() {
    final filters = ["All", "Unread"];
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final isSelected = index == selectedFilterIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilterIndex = index;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _notificationTile(NotificationEntity notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xFFE6F7FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal.withOpacity(0.1),
            backgroundImage: notification.profileImage.isNotEmpty
                ? NetworkImage(notification.profileImage)
                : null,
            child: notification.profileImage.isEmpty
                ? const Icon(Icons.notifications, color: Colors.teal)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.text, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  formatchatDate(notification.date.toIso8601String()),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
