import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/custom_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);

    try {
      await Supabase.instance.client.auth.signOut();

      // Navigate after sign out finishes
      if (mounted) {
        GoRouter.of(context).go(AppRouter.login);
      }
    } catch (e) {
      debugPrint("Sign-out error: $e");
      setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Out',
            style: TextStyle(color: AppColors.buttonBg,
            fontWeight: FontWeight.w700,
            ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Flexible(
          child: const Text('Are you sure you want to Sign Out?',
                style: TextStyle(color: AppColors.buttonBg,
                fontWeight: FontWeight.w700,
                fontSize: 18),
              ),
        ),
          SizedBox(
            height: 80.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26, right: 26),
            child: Center(
              child:  CustomButton(
                text: "Sign Out",
                onTap: _signOut ,
                textColor: AppColors.white,
                bgColor: AppColors.red,
                loading: _isSigningOut,
              ),
            ),
          ),

        ],
      ),
    );
  }
}