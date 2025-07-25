class NotificationEntity {
  final String actorId;
  final String userName;
  final String profileImage;
  final String text;
  final String? postId;
  final DateTime date;
  final bool isRead;

  NotificationEntity({
    required this.actorId,
    required this.userName,
    required this.profileImage,
    required this.text,
    required this.date,
    this.postId,
    this.isRead = false,
  });
}
