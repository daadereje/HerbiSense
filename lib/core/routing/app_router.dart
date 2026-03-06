import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/directory/directory_screen.dart';
import '../../presentation/recommendations/recommendations_screen.dart';
import '../../presentation/about/about_screen.dart';
import '../../presentation/auth/login/login_screen.dart';
import '../../presentation/auth/register/register_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/directory',
        name: 'directory',
        builder: (context, state) => const DirectoryScreen(),
      ),
      GoRoute(
        path: '/recommendations',
        name: 'recommendations',
        builder: (context, state) => const RecommendationsScreen(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // Add other routes here
    ],
  );
});
