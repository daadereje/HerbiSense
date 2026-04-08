import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/directory/directory_screen.dart';
import '../../presentation/recommendations/recommendations_screen.dart';
import '../../presentation/about/about_screen.dart';
import '../../presentation/auth/login/login_screen.dart';
import '../../presentation/auth/register/register_screen.dart';
import '../../presentation/contact/contact_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import '../constants/data/repositories/auth_repository.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authToken = ref.watch(authTokenProvider);
  final isAuthenticated = authToken != null && authToken.isNotEmpty;

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (state.uri.path == '/' && isAuthenticated) {
        return '/recommendations';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactScreen(),
      ),
      // Add other routes here
    ],
  );
});
