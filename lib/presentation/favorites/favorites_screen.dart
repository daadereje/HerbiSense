import 'package:flutter/material.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/strings.dart';
import 'package:herbisense/core/widgets/cards/info_card.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/widgets/shared/header_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = _mockFavorites;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: AppStrings.favoritesTitle,
            subtitle: AppStrings.favoritesSubtitle,
            showBack: false,
            height: 160,
            solidColor: true,
            titleStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: favorites.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummary(favorites.length),
                        const SizedBox(height: 16),
                        ...favorites.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: InfoCard(
                              title: item.title,
                              description: item.description,
                              tags: item.tags,
                              extra: item.extra,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(int count) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, size: 18, color: Colors.redAccent),
              const SizedBox(width: 6),
              Text(
                '${AppStrings.favoritesCountLabel}: $count',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          children: const [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              AppStrings.favoritesEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteItem {
  final String title;
  final String description;
  final List<String> tags;
  final String? extra;

  const _FavoriteItem({
    required this.title,
    required this.description,
    required this.tags,
    this.extra,
  });
}

/// Temporary mock data until favorites are backed by storage/backend.
const List<_FavoriteItem> _mockFavorites = [
  _FavoriteItem(
    title: 'Frankincense (Etan)',
    description: 'Resin traditionally used for soothing, purification, and calming aromas.',
    tags: ['Soothing', 'Aromatic', 'Antimicrobial'],
    extra: 'Pairs well with myrrh for rituals and skin balms',
  ),
  _FavoriteItem(
    title: 'Black Seed (Tikur Azmud)',
    description: 'Oil used for supporting skin barrier and reducing inflammation.',
    tags: ['Anti-inflammatory', 'Barrier Support', 'Traditional Remedy'],
    extra: 'Test on small area first if you have sensitive skin',
  ),
  _FavoriteItem(
    title: 'Rosemary (Yetut Zaf)',
    description: 'Stimulating herb used to boost circulation and freshness.',
    tags: ['Circulation', 'Refreshing', 'Antioxidant'],
    extra: 'Great in steam infusions or diluted oils',
  ),
];
