// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:social_media_app/features/authentication/domain/entities/user_entity/location.dart';

class RegisterParams {
  final bool certifiedDoctor;
  final String firstName;
  final String userName;
  final String lastName;
  final String birthDate;
  final String email;
  final String password;
  final String country;
  final String city;
  final String gender;
  final String? bio;
  final List<String> preferredTopics;
  RegisterParams( {
    this.bio,
    required this.certifiedDoctor,
    required this.firstName,
    required this.userName,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.password,
    required this.country,
    required this.city,
    required this.gender,
    required this.preferredTopics,
  });
}
