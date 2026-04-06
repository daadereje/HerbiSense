import 'package:flutter/material.dart';
import 'package:herbisense/presentation/favorites/favorites_screen.dart';
import '../../../presentation/recommendations/recommendations_screen.dart';
import '../../../presentation/profile/profile_screen.dart';
import '../../../presentation/discover/discover_screen.dart';
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RecommendationsScreen()),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DiscoverScreen()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
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
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
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
