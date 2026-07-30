import 'package:flutter/material.dart';

class NotificationService {
  static void showInAppBanner(BuildContext context, {required String title, required String message, bool isError = false}) {
    final snackBar = SnackBar(
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? const Color(0xFFD63031) : const Color(0xFF6C5CE7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          Icon(
            isError ? Icons.warning_amber_rounded : Icons.auto_awesome,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
