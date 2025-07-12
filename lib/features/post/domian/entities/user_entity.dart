import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String userName;
  final String profileImage;

  const User({
    required this.id,
    required this.userName,
    required this.profileImage,
  });

  @override
  List<Object?> get props => [id, userName, profileImage];
}
