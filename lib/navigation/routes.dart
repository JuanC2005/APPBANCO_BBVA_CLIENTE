import 'package:go_router/go_router.dart';
import '../view/auth/login_screen.dart';
import '../view/home/dashboard_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
