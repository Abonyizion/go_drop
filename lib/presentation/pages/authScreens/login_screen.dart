import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_drop/core/constants/app_colors.dart';
import 'package:go_drop/presentation/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/general_constants.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/custom_textField.dart';
import '../../widgets/custome_alert_dialogue.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {

      CustomAlertDialog.show(
        context,
        title: "Attention",
        content: "Email and password required.",
        onPressed: () {
          context.pop();
        },
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (response.user != null) {
        // Navigate to Order Page
        context.go(AppRouter.orderCreation);
      }
    } on PostgrestException catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      CustomAlertDialog.show(
        context,
        title: "Attention",
        content: "Network error, try again",
        onPressed: () {
          context.pop();
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              // height: 250,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.buttonBg,
                    Color(0xFF19725F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: 160.h,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: SingleChildScrollView(
                padding: GeneralConstants.scaffoldPadding,
                child: Column(
                  children: [
                    CustomTextField(
                      icon: Icons.email_outlined,
                      hint: "Email Address",
                      obscure: false,
                      controller: emailController,
                    ),

                    const SizedBox(height: 22),

                    CustomTextField(
                        icon: Icons.lock_outline,
                        hint: "Password",
                        obscure: true,
                        controller: passwordController,
                        showToggle: true),

                    const SizedBox(height: 60),

                    CustomButton(
                      text: "Login",
                      onTap: loginUser ,
                      textColor: AppColors.white,
                      bgColor: AppColors.buttonBg,
                      loading: _isLoading,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Or",
                      style: TextStyle(
                        color: AppColors.buttonBg,
                        fontSize: 14,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      text: "Create an Account",
                      onTap: () => context.push(AppRouter.register),
                      textColor: AppColors.buttonBg,
                      bgColor: AppColors.creatAcBg,
                      loading: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
