import 'package:flutter/material.dart';

class CustomSnackBar {
  static bool isShown = false;

  static showSnackBar({required String message, required BuildContext context}) {
    if (!isShown) {
      isShown = true;
      return ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              duration: const Duration(seconds: 2),
            ),
          )
          .closed
          .then((value) {
        isShown = false;
      });
    }
  }
}

