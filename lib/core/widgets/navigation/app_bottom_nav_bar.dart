import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';

/// Reusable bottom navigation bar used across Home, Recommendations and Profile.
/// Pass the currently selected index to highlight the active tab.
class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({super.key, required this.currentIndex});

  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex) return; // No-op if already on that tab

    switch (index) {
      case 0:
        context.go('/recommendations');
        break;
      case 1:
        context.go('/favorites');
        break;
      case 2:
        context.go('/discover');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.secondaryGreen,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) => _handleTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.recommend_outlined),
          activeIcon: Icon(Icons.recommend),
          label: 'Recommend',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library_outlined),
          activeIcon: Icon(Icons.photo_library),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
