import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/data/models/skin_concern_model.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/directory/directory_screen.dart';
import '../../presentation/recommendations/recommendations_screen.dart';
import '../../presentation/recommendations/condition_detail_screen.dart';
import '../../presentation/favorites/favorites_screen.dart';
import '../../presentation/discover/discover_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/about/about_screen.dart';
import '../../presentation/auth/login/login_screen.dart';
import '../../presentation/auth/register/register_screen.dart';
import '../../presentation/contact/contact_screen.dart';
import '../../presentation/splash/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
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
        path: '/condition-details',
        name: 'condition-details',
        builder: (context, state) {
          final concern = state.extra as SkinConcernModel?;
          if (concern == null) {
            // Handle error case - maybe navigate back
            return const Scaffold(
              body: Center(child: Text('Condition not found')),
            );
          }
          return ConditionDetailScreen(concern: concern);
        },
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
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // Add other routes here
    ],
  );
});
