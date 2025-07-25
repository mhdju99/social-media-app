import 'package:equatable/equatable.dart';
class User extends Equatable {
  final String id;
  final String userName;
  final String profileImage;
  final bool isfollowMe;

  const User({
    this.isfollowMe = false,
    required this.id,
    required this.userName,
    required this.profileImage,
  });

  User copyWith({
    String? id,
    String? userName,
    String? profileImage,
    bool? isfollowMe,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profileImage: profileImage ?? this.profileImage,
      isfollowMe: isfollowMe ?? this.isfollowMe,
    );
  }

  @override
  List<Object?> get props => [id, userName, profileImage, isfollowMe];
}
