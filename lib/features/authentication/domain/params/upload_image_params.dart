// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

class UploadImageParams {
  FormData image;
  String token;
  UploadImageParams({
    required this.image,
    required this.token,
  });

}
