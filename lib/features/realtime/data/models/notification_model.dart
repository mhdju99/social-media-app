import 'package:hive/hive.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 0)
class NotificationModel extends NotificationEntity with HiveObjectMixin {
  @HiveField(0)
  final String actorId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String profileImage;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final String? postId;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final bool isRead;

  NotificationModel({
    required this.actorId,
    required this.userName,
    required this.profileImage,
    required this.text,
    required this.date,
    this.postId,
    this.isRead = false,
  }) : super(
          actorId: actorId,
          userName: userName,
          profileImage: profileImage,
          text: text,
          postId: postId,
          date: date,
          isRead: isRead,
        );
factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      actorId: json['actorId'] ?? '',
      userName: json['userName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      text: json['text'] ?? '',
      postId: json['postId'] ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  NotificationModel copyWith({
    String? actorId,
    String? userName,
    String? profileImage,
    String? text,
    String? postId,
    DateTime? date,
    bool? isRead,
  }) {
    return NotificationModel(
      actorId: actorId ?? this.actorId,
      userName: userName ?? this.userName,
      profileImage: profileImage ?? this.profileImage,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
    );
  }
}
