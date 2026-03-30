import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/strings.dart';
import 'package:herbisense/core/widgets/cards/info_card.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/widgets/shared/header_widget.dart';
import 'package:herbisense/data/models/favorite_model.dart';
import 'package:herbisense/data/repositories/favorites_repository.dart';

final favoritesProvider = FutureProvider<List<FavoriteModel>>((ref) {
  final repo = ref.read(favoritesRepositoryProvider);
  return repo.getFavorites();
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: AppStrings.favoritesTitle,
            subtitle: AppStrings.favoritesSubtitle,
            showBack: false,
            height: 120,
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
              child: favoritesAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => _buildError(err.toString()),
                data: (favorites) => favorites.isEmpty
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
                                title: item.name,
                                description: item.description,
                                tags: item.tags,
                                extra: item.extraNote,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                // 'register to app to see your favorites',
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

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              'Failed to load favorites',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Register or login to the app to see your favorites",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
