import 'package:social_media_app/features/post/data/models/post_model/postDetailsModel.dart';

import '../../domain/entities/user_entity.dart';

class UserProfileModel {
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthDate;
  final String profileImage;
  final bool certifiedDoctor;
  final List<String> followers;
  final List<String> following;
  final List<String> blockedUsers;
  final List<String> preferredTopics;
  final LocationModel location;
  final List<PostDetailsModel> posts;
    final DateTime? lastSeenAt;
  final String? about;
  final List<String>? files;

  UserProfileModel({
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
  });
  factory UserProfileModel.fromResponse(Map<dynamic, dynamic> json) {
    return UserProfileModel.fromJson(json['user']);
  }
  factory UserProfileModel.fromJson(Map<dynamic, dynamic> json) {
        

    return UserProfileModel(
      userName: json['userName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      birthDate: DateTime.tryParse(json['birthDate'] ?? '') ?? DateTime(1970),
      profileImage: json['profileImage'] ?? '',
      certifiedDoctor: json['certifiedDoctor'] ?? false,
      followers:  (json['followers'] as List)
    .map((item) => item['user'] as String)
    .toList(),

      following: (json['following'] as List)
          .map((item) => item['user'] as String)
          .toList(),
blockedUsers: (json['blockedUsers'] as List?)
              ?.map((item) => item['blockedUserId'].toString())
              .toList() ??
          [],
      preferredTopics: List<String>.from(json['preferredTopics'] ?? []),
      location: LocationModel.fromJson(
          json['location'] ?? {'country': '', 'city': ''}),
    posts: (json['posts'] as List?)
              ?.where((element) => element["deletedFlag"] != true)
              ?.map((e) => PostDetailsModel.fromJson(e))
              .toList() ??
          [],
            lastSeenAt: json['lastSeenAt'] != null
          ? DateTime.tryParse(json['lastSeenAt'])
          : null,
      about: json['about'],
      files: json['files'] != null ? List<String>.from(json['files']) : null,
    );
  }
  UserProfile toEntity() {
    return UserProfile(
      userName: userName,
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate,
      profileImage: profileImage,
      certifiedDoctor: certifiedDoctor,
      followers: followers,
      following: following,
      blockedUsers: blockedUsers,
      preferredTopics: preferredTopics,
      location: location.toEntity(),
         lastSeenAt: lastSeenAt,
      about: about,
      files: files,
      // posts: [],
      posts: posts.map((e) => e.toEntity()).toList(),
    );
  }
}

class LocationModel {
  final String country;
  final String city;

  LocationModel({required this.country, required this.city});

  factory LocationModel.fromJson(Map<dynamic, dynamic> json) {
    return LocationModel(
      country: json['country'],
      city: json['city'],
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(country: country, city: city);
  }
}
