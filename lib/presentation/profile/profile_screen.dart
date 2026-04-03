import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/languages/strings.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/constants/data/models/user_model.dart';
import 'package:herbisense/core/constants/data/repositories/auth_repository.dart';
import 'package:herbisense/presentation/auth/login/login_screen.dart';
import 'package:herbisense/presentation/saved/saved_herbs_screen.dart';

import '../feedback/feedback_screen.dart';

final currentUserProvider = FutureProvider<UserModel?>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return repo.getCurrentUser();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
      appBar: AppBar(
        backgroundColor: AppColors.secondaryGreen,
        elevation: 0,
        // toolbarHeight: 160.0,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(label: 'Account'),
          userAsync.when(
            loading: () => const _ProfilePlaceholder(),
            error: (err, _) => _ProfileError(message: err.toString()),
            data: (user) {
              if (user == null) {
                return _ProfileError(
                  message:
                      'You are not logged in. Please sign in to view your profile.',
                  action: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                );
              }
              return _ProfileHeader(
                name: user.fullName.isNotEmpty ? user.fullName : 'Guest',
                email: user.email.isNotEmpty ? user.email : 'Unknown',
                role: user.role,
              );
            },
          ),
          const SizedBox(height: 20),
          // _NavTile(
          //   icon: Icons.person,
          //   // title: 'My Profile',
          //   title: 'About You',
          //   subtitle: 'View your profile and journey',
          //   onTap: null, // navigation removed per request
          // ),
          const SizedBox(height: 16),
          _SectionTitle(label: 'Engage'),
          _NavTile(
            icon: Icons.feedback_outlined,
            title: 'Provide Feedback',
            subtitle: 'Tell us how we can improve',
            onTap: () => _push(context, const FeedbackScreen()),
          ),
          const SizedBox(height: 16),
          _SectionTitle(label: 'Library'),
          _NavTile(
            icon: Icons.bookmark_outlined,
            title: 'Saved Herbs',
            subtitle: 'See herbs you bookmarked',
            onTap: () => _push(context, const SavedHerbsScreen()),
          ),
          const SizedBox(height: 10),
          // _NavTile(
          //   icon: Icons.favorite_border,
          //   title: 'Favorites',
          //   subtitle: 'Your favorite herbs and remedies',
          //   onTap: () => _push(context, const FavoritesScreen()),
          // ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? role;

  const _ProfileHeader({

    required this.name,
    required this.email,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.softGreen,
              child: const Icon(Icons.person, color: AppColors.secondaryGreen, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (role != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryGreen,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.softGreen,
              child:
                  Icon(Icons.person, color: AppColors.secondaryGreen, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 120,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 180,
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final String message;
  final VoidCallback? action;
  const _ProfileError({required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Failed to load account: $message',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            if (action != null)
              TextButton(
                onPressed: action,
                child: const Text('Sign In'),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _NavTile({
    this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: icon == null
            ? null
            : CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.softGreen,
                child: Icon(icon, color: AppColors.secondaryGreen),
              ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
