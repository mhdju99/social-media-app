import 'package:flutter/material.dart';
import 'package:social_media_app/features/authentication/presentation/screens/logInPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/signUpPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/splashScreen.dart';

class Routes {
  static const String initialRoute = "/";
  static const String SignUP = "/homeScreen";
  static const String LogIn = "/LogIn";
}

final routes = {
  Routes.initialRoute: (context) => SplashScreen(),
  Routes.LogIn: (context) => LogIn(),
  // Routes.SignUP: (context) => SignUP()
};
