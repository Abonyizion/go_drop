import 'package:flutter/material.dart';
import 'package:go_drop/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

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
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              if (onPressed != null) {
                onPressed();
              }
            },
            child: Text(buttonText,
              style: TextStyle(
                color: AppColors.buttonBg
              ) ,),
          ),
        ],
      ),
    );
  }
}
