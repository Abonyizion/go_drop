// app_router.dart
import 'package:go_router/go_router.dart';
import '../../presentation/pages/authScreens/login_screen.dart';
import '../../presentation/pages/authScreens/register_screen.dart';
import '../../presentation/pages/create_order_screen/create_order_screen.dart';
import '../../presentation/pages/create_order_screen/order_tracking_screen.dart';
import '../../presentation/pages/create_order_screen/signout.dart';
import '../../presentation/pages/splash/splash_screen.dart';

class AppRouter {
  /// ROUTE PATHS
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String orderCreation = '/orderCreation';
  static const String settings = '/settings';

  // This is now a DYNAMIC route → no static path const needed
  static const String orderTracking = 'orderTracking'; // name only (used with pushNamed)

  /// GOROUTER SETUP
  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: login, builder: (_, __) => const AuthScreen()),
      GoRoute(path: register, builder: (_, __) => const CreateAccountPage()),
      GoRoute(path: orderCreation, builder: (_, __) => const OrderCreationScreen()),
      GoRoute(path: settings, builder: (_, __) => const SettingsPage()),



      // DYNAMIC ROUTE — this is the correct way
      GoRoute(
        path: '/orderTracking/:orderId',        // <-- dynamic segment
        name: orderTracking,                     // <-- name stays the same
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;  // get the ID safely
          return OrderTrackingScreen(orderId: orderId);
        },
      ),
    ],
  );
}