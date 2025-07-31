import 'package:social_media_app/features/authentication/domain/entities/user_entity/location.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';

import 'location.dart' as lo;

class UserModel {
  lo.Location? location;
  String? id;
  String? userName;
  List<dynamic>? followers;
  List<dynamic>? following;
  bool? certifiedDoctor;
  String? firstName;
  List<dynamic>? posts  ;
  String? lastName;
  DateTime? birthDate;  
  String? email;
  List<dynamic>? preferredTopics;
  List<dynamic>? files;
  List<dynamic>? verificationCodes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  UserModel({
    this.location,
    this.id,
    this.userName,
    this.followers,
    this.following,
    this.certifiedDoctor,
    this.firstName,
    this.posts,
    this.lastName,
    this.birthDate,
    this.email,
    this.preferredTopics,
    this.files,
    this.verificationCodes,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
  factory UserModel.fromResponse(Map<dynamic, dynamic> json) {
    return UserModel.fromJson(json['user']);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        location: json['location'] == null
            ? null
            : lo.Location.fromJson(json['location'] as Map<String, dynamic>),
id: (json['id'] ?? json['_id'] ?? "0").toString(),
        userName: json['userName'] as String?,
        followers: json['followers'] as List<dynamic>?,
        following: json['following'] as List<dynamic>?,
        certifiedDoctor: json['certifiedDoctor'] as bool?,
        firstName: json['firstName'] as String?,
        posts: json['posts'] as List<dynamic>?,
        lastName: json['lastName'] as String?,
        birthDate: json['birthDate'] == null
            ? null
            : DateTime.parse(json['birthDate'] as String),
        email: json['email'] as String?,
        preferredTopics: json['preferredTopics'] as List<dynamic>,
        files: json['files'] as List<dynamic>?,
        verificationCodes: json['verificationCodes'] as List<dynamic>?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        '_id': id,
        'userName': userName,
        'followers': followers,
        'following': following,
        'certifiedDoctor': certifiedDoctor,
        'firstName': firstName,
        'posts': posts,
        'lastName': lastName,
        'birthDate': birthDate?.toIso8601String(),
        'email': email,
        'preferredTopics': preferredTopics,
        'files': files,
        'verificationCodes': verificationCodes,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  UserEntity toEntity() => UserEntity(
      birthDate: birthDate,
      certifiedDoctor: certifiedDoctor,
      email: email,
      firstName: firstName,
      followers: followers,
      following: following,
      id: id,
      lastName: lastName,
      location: Location(city: location?.city, country: location?.country),
      preferredTopics: preferredTopics);
}
