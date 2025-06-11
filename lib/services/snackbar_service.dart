import 'package:flutter/material.dart';

class SnackBarService {
  static void showErrorSnackBar({
    required BuildContext context,
    required String message,
    EdgeInsetsGeometry? margin,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Text(message,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
          )),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'dismiss',
        textColor: Colors.white,
        onPressed: () => hideSnackBar(context),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
