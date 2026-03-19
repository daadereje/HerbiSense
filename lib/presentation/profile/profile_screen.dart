import 'package:flutter/material.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/strings.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/presentation/about/about_screen.dart';
import 'package:herbisense/presentation/contact/contact_screen.dart';
import 'package:herbisense/presentation/favorites/favorites_screen.dart';
import 'package:herbisense/presentation/saved/saved_herbs_screen.dart';

import '../feedback/feedback_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
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
          const _ProfileHeader(
            name: 'Abeba Tesfaye',
            email: 'email@gmail.com',
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

  const _ProfileHeader({

    required this.name,
    required this.email,
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
                ],
              ),
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
