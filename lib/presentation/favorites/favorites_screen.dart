import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/common/network/api_client.dart';
import 'package:herbisense/common/network/api_endpoints.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/languages/favorites_strings.dart';
import 'package:herbisense/core/widgets/cards/info_card.dart';
import 'package:herbisense/core/state/language_provider.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/widgets/shared/header_widget.dart';
import 'package:herbisense/core/constants/data/models/favorite_model.dart';
import 'package:herbisense/core/constants/data/repositories/favorites_repository.dart';
import 'package:herbisense/core/constants/data/repositories/herb_repository.dart';
import 'package:herbisense/presentation/discover/herb_detail_screen.dart';
import 'package:herbisense/core/constants/data/models/herb_model.dart';

final favoritesProvider = FutureProvider<List<FavoriteModel>>((ref) {
  final repo = ref.read(favoritesRepositoryProvider);
  return repo.getFavorites();
});

final favoriteHerbProvider =
    FutureProvider.family<HerbModel?, int>((ref, herbId) async {
  final language = ref.watch(languageProvider);
  final repo = ref.read(herbRepositoryProvider);
  return repo.getHerbById(herbId.toString(), language: language);
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final language = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);
    final strings = FavoritesStrings.fromLanguage(language);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: strings.favoritesTitle,
            subtitle: strings.favoritesSubtitle,
            showBack: false,
            height: 120,
            solidColor: true,
            language: language,
            languageOptions: const ['eng', 'amh', 'or'],
            onLanguageSelected: languageNotifier.setLanguage,
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
                error: (err, _) => _buildError(err.toString(), strings),
                data: (favorites) => favorites.isEmpty
                    ? _buildEmptyState(strings)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummary(favorites.length, strings),
                          const SizedBox(height: 16),
                          ...favorites.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _FavoriteHerbTile(item: item),
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

  Widget _buildSummary(int count, FavoritesStrings strings) {
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
                '${strings.favoritesCountLabel}: $count',
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

  Widget _buildEmptyState(FavoritesStrings strings) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          children: [
            const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              strings.favoritesEmpty,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message, FavoritesStrings strings) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              strings.favoritesLoadErrorTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.favoritesLoadErrorBody,
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

class _FavoriteHerbTile extends ConsumerWidget {
  final FavoriteModel item;
  const _FavoriteHerbTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final strings = FavoritesStrings.fromLanguage(language);
    if (item.herbId == null) {
      return InfoCard(
        title: item.name,
        description: item.description,
        tags: item.tags,
        extra: item.extraNote,
      );
    }

    final herbAsync = ref.watch(favoriteHerbProvider(item.herbId!));

    return herbAsync.when(
      loading: () => const _SkeletonTile(),
      error: (_, __) => InfoCard(
        title: item.name,
        description: strings.favoritesLinkedHerbError,
        tags: item.tags,
        extra: item.extraNote,
      ),
      data: (herb) {
        if (herb == null) {
          return InfoCard(
            title: item.name,
            description: strings.favoritesHerbNotFound,
            tags: item.tags,
            extra: item.extraNote,
          );
        }
        return _HerbListTile(
          herb: herb,
          favoriteId: item.id.toString(),
          strings: strings,
        );
      },
    );
  }
}

class _HerbListTile extends ConsumerWidget {
  final HerbModel herb;
  final String favoriteId;
  final FavoritesStrings strings;
  const _HerbListTile({required this.herb, required this.favoriteId, required this.strings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final language = ref.watch(languageProvider);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HerbDetailScreen(herb: herb)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: _MiniImage(url: herb.imageUrl),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: Colors.black45,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HerbDetailScreen(herb: herb),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        herb.nameFor(language),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    herb.scientificName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.secondaryGreen,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        herb.isVerified ? Icons.verified : Icons.eco_outlined,
                        size: 16,
                        color: AppColors.secondaryGreen,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          herb.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.grey),
            IconButton(
              icon: const Icon(Icons.open_in_new,
                  color: AppColors.secondaryGreen),
              tooltip: strings.favoritesOpenTooltip,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => HerbDetailScreen(herb: herb)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.redAccent),
              tooltip: strings.favoritesRemoveTooltip,
              onPressed: () async {
                final parsedId = int.tryParse(favoriteId);
                try {
                  await apiClient.delete(
                      '${ApiEndpoints.favorites}/${parsedId ?? favoriteId}');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(strings.favoritesRemovedSnack),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    ref.invalidate(favoritesProvider);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${strings.favoritesRemoveFailSnack}: $e'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniImage extends StatelessWidget {
  final String? url;
  const _MiniImage({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _placeholder();
    }
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 32,
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmer(width: 140),
                const SizedBox(height: 8),
                _shimmer(width: 110),
                const SizedBox(height: 12),
                _shimmer(width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer({required double width}) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
