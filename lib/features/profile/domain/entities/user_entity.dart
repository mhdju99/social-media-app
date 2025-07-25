import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';

class UserProfile {
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthDate;
  final String profileImage;
  final bool certifiedDoctor;
  final bool isfollow;
  final List<String> followers;
  final List<String> following;
  final List<String> blockedUsers;
  final List<String> preferredTopics;
  final LocationEntity location;
  final List<PostDetails> posts;
  final DateTime? lastSeenAt;
  final String? about;
  final List<String>? files;

  const UserProfile({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.profileImage,
    required this.certifiedDoctor,
    required this.followers,
    required this.following,
    required this.blockedUsers,
    required this.preferredTopics,
    required this.location,
    required this.posts,
    this.lastSeenAt,
    this.about,
    this.files,
    this.isfollow = false,
  });

  UserProfile copyWith({
    String? userName,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? birthDate,
    String? profileImage,
    bool? certifiedDoctor,
    bool? isfollow,
    List<String>? followers,
    List<String>? following,
    List<String>? blockedUsers,
    List<String>? preferredTopics,
    LocationEntity? location,
    List<PostDetails>? posts,
    DateTime? lastSeenAt,
    String? about,
    List<String>? files,
  }) {
    return UserProfile(
      userName: userName ?? this.userName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      profileImage: profileImage ?? this.profileImage,
      certifiedDoctor: certifiedDoctor ?? this.certifiedDoctor,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      preferredTopics: preferredTopics ?? this.preferredTopics,
      location: location ?? this.location,
      posts: posts ?? this.posts,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      about: about ?? this.about,
      files: files ?? this.files,
      isfollow: isfollow ?? this.isfollow,
    );
  }
}

class LocationEntity {
  final String country;
  final String city;

  const LocationEntity({
    required this.country,
    required this.city,
  });

  LocationEntity copyWith({
    String? country,
    String? city,
  }) {
    return LocationEntity(
      country: country ?? this.country,
      city: city ?? this.city,
    );
  }
}
