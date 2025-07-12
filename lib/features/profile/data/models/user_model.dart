import 'package:social_media_app/features/post/data/models/post_model/post_model.dart';

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
  final List<PostModel> posts;

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
  });
  factory UserProfileModel.fromResponse(Map<dynamic, dynamic> json) {
    return UserProfileModel.fromJson(json['user']);
  }
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthDate: DateTime.parse(json['birthDate']),
      profileImage: json['profileImage'],
      certifiedDoctor: json['certifiedDoctor'],
      followers: List<String>.from(json['followers']),
      following: List<String>.from(json['following']),
      blockedUsers: List<String>.from(json['blockedUsers']),
      preferredTopics: List<String>.from(json['preferredTopics']),
      location: LocationModel.fromJson(json['location']),
      posts: (json['posts'] as List)
          .map((postJson) => PostModel.fromJson(postJson))
          .toList(),
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
      posts: posts.map((e) => e.toEntity()).toList(),
    );
  }
}

class LocationModel {
  final String country;
  final String city;

  LocationModel({required this.country, required this.city});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      country: json['country'],
      city: json['city'],
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(country: country, city: city);
  }
}
