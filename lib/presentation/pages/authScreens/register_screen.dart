import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_drop/core/constants/general_constants.dart';
import 'package:go_drop/presentation/widgets/custom_textField.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/custome_alert_dialogue.dart';


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool agree = false;
  bool _isLoading = false;



  final supabase = Supabase.instance.client;

  Future<void> registerUser() async {
     FocusScope.of(context).unfocus();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();


    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await Supabase.instance.client.from('users').insert({
          'auth_id': response.user!.id,
          'name': name,
          'role': 'customer',
        });

        if (!mounted) return;

        setState(() => _isLoading = false);

        await CustomAlertDialog.show(
          context,
          title: "Success",
          content: "Account created successfully.",
        );


        if (!mounted) return;
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0E574A),
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
                    "Register",
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

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                padding: GeneralConstants.scaffoldPadding,
                child: Column(
                  children: [
                    CustomTextField(
                      icon: Icons.person,
                      hint: "Full Name",
                      obscure: false,
                      controller: nameController,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      icon: Icons.email_outlined,
                      hint: "Email Address",
                      obscure: false,
                      controller: emailController,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      icon: Icons.lock_outline,
                      hint: "Password",
                      obscure: true,
                      controller: passwordController,
                      showToggle: true),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Checkbox(
                          value: agree,
                          activeColor: AppColors.buttonBg,
                          onChanged: (v) => setState(() => agree = v!),
                        ),
                        const Text("I agree to the "),
                        Text(
                          "Terms & Privacy",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    CustomButton(
                      text: "Sign Up",
                      onTap: registerUser,
                      textColor: AppColors.white,
                      bgColor:  AppColors.buttonBg,
                      loading: _isLoading,
                    ),
                    const SizedBox(height: 22),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Have an account? "),
                          SizedBox(
                            width: 6,
                          ),
                          InkWell(
                            onTap: () => context.pop(),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: AppColors.textGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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