part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetUserProfileEvent extends ProfileEvent {
  final String userId;

  const GetUserProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
class GetMyProfileEvent extends ProfileEvent {

  const GetMyProfileEvent();

}
class GetProfilePhotoAndNameEvent extends ProfileEvent {
  final List<String> userId;

  const GetProfilePhotoAndNameEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ModifyProfileEvent extends ProfileEvent {
  final String? userName;
  final File? photo;
  final String? firstName;
  final List<String>? preferredTopics;
  final String? lastName;
  final String? birthDate;
  final String? email;
  final String? country;
  final String? city;
  final String? about;

  const ModifyProfileEvent({
    this.userName,
    this.photo,
    this.firstName,
    this.preferredTopics,
    this.lastName,
    this.birthDate,
    this.email,
    this.country,
    this.city,
    this.about,
  });

  @override
  List<Object?> get props => [
        userName,
        photo,
        firstName,
        preferredTopics,
        lastName,
        birthDate,
        email,
        country,
        city,
        about,
      ];
}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class BlockUnblockUserEvent extends ProfileEvent {
  final String userId;

  const BlockUnblockUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FollowUnfollowUserEvent extends ProfileEvent {
  final String userId;

  const FollowUnfollowUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
