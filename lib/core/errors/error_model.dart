import 'package:flutter/foundation.dart';

class ErrorModel {
  final int? status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});
  factory ErrorModel.fromJson(Map jsonData) {
        // debugPrint('📛 📛 📛 📛 📛 📛 📛 📛 📛 📛 📛 ErrorModel JSON: $jsonData');

    return ErrorModel(
      errorMessage: jsonData["message"],
      status: jsonData["status"],
    );
  }
}
