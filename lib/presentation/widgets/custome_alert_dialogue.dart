import 'package:flutter/material.dart';
import 'package:go_drop/core/constants/app_colors.dart';

class CustomAlertDialog {
  static Future<void> show(
    BuildContext context, {
    String title = "Alert",
    required String content,
    String buttonText = "OK",
    VoidCallback? onPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); //  SAFE POP
              if (onPressed != null) onPressed();
            },
            child: Text(
              buttonText,
              style: const TextStyle(color: AppColors.buttonBg),
            ),
          ),
        ],
      ),
    );
  }
}
