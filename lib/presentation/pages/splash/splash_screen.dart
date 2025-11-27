import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_drop/core/constants/general_constants.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/custom_button.dart';



class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: GeneralConstants.scaffoldPadding,
        decoration: BoxDecoration(
          color: AppColors.deepNavyBlue,
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),  // Background per slide
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                  height: 70.h),
              Expanded(
                child: Text(
                    "Your Delivery, \nJust a Tap Away",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40.sp,
                      color: AppColors.buttonBg,
                    ),
                  ),
              ),
              SizedBox(
                  height: 80.h),
              CustomButton(
                text: "Get Started",
                onTap: () => context.go(AppRouter.login),
                textColor: AppColors.white,
                bgColor:  AppColors.buttonBg,
              ),
              SizedBox(
                  height: 80.h),

            ],
          ),
        ),
      ),
    );
  }
}
