import 'package:flutter/material.dart';

class MySnackBar {
  Future<void> showSnackBar(
      {required String content,
      required BuildContext context,
      required Color backgroundColor,
      Duration duration = const Duration(
        milliseconds: 500,
      )}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.grey[300]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: duration,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
