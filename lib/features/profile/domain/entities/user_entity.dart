import 'package:social_media_app/features/post/domian/entities/postDetails_entity.dart';

class UserProfile {
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
  });
}

class LocationEntity {
  final String country;
  final String city;

  const LocationEntity({
    required this.country,
    required this.city,
  });
}
