import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_drop/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool? showToggle;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hint,
    required this.obscure,
    required this.controller,
    this.showToggle,
    this.keyboardType,

  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _hide;

  @override
  void initState() {
    super.initState();
    _hide = widget.obscure; // only hide when obscure is true
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(

            color: Colors.grey.shade400, width: 1.w),
      ),
      child: TextField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: widget.obscure ? _hide : false,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: AppColors.grey
          ),

          // Only show toggle when needed
          suffixIcon: (widget.showToggle == true && widget.obscure)
              ? IconButton(
            icon: Icon(
              _hide ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              setState(() => _hide = !_hide);
            },
          )
              : null,
        ),
      ),
    );
  }
}
