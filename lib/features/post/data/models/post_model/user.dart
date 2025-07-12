import 'package:social_media_app/features/post/domian/entities/user_entity.dart';


class UserModel {
  final String id;
  final String userName;
  final String profileImage;

  UserModel({
    required this.id,
    required this.userName,
    required this.profileImage,
  });
  factory UserModel.fromResponse(Map<dynamic, dynamic> json) {
    return UserModel.fromJson(json['users']);
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      userName: json['userName'],
      profileImage: json['profileImage'],
    );
  }

  User toEntity() {
    return User(
      id: id,
      userName: userName,
      profileImage: profileImage,
    );
  }
}
