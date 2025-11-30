import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/routing/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start fade-in after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runAnimation();
    });
  }

  Future<void> _runAnimation() async {
    final session = Supabase.instance.client.auth.currentSession;

    // 1️⃣ Fade in
    setState(() => _opacity = 1.0);
    await Future.delayed(const Duration(seconds: 2));

    // If user is logged in → fade out and go home
    if (session != null) {
      await _fadeOutAndNavigate(AppRouter.orderCreation);
      return;
    }

    // 2️⃣ Hold after fade-in
    await Future.delayed(const Duration(seconds: 2));

    // 3️⃣ Fade out and go to login
    await _fadeOutAndNavigate(AppRouter.login);
  }

  Future<void> _fadeOutAndNavigate(String route) async {
    if (!mounted) return;

    // Fade out
    setState(() => _opacity = 0.0);
    await Future.delayed(const Duration(seconds: 1));

    // Navigate after fade-out
    if (!mounted) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
