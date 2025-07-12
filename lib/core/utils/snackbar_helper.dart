import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SnackbarHelper {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
