import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final bool? loading;
  final double borderRadius;
  final Color textColor;
  final Color bgColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = double.infinity,
    this.borderRadius = 32,
    required this.textColor,
    required this.bgColor,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = loading ?? false;
    return SizedBox(
      width: width,
      height: 52.h,
      child: Material(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: isLoading ? null : onTap,
            child: Center(
              child: isLoading
                  ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
