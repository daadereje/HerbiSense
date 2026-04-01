import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/strings.dart';
import 'package:herbisense/core/widgets/cards/info_card.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/widgets/shared/header_widget.dart';
import 'package:herbisense/core/widgets/inputs/search_bar.dart';
import 'package:herbisense/data/models/herb_model.dart';
import 'package:herbisense/data/repositories/saved_herbs_repository.dart';

final savedHerbsProvider = FutureProvider<List<HerbModel>>((ref) {
  final repo = ref.read(savedHerbsRepositoryProvider);
  return repo.getSavedHerbs();
});

class SavedHerbsScreen extends ConsumerStatefulWidget {
  const SavedHerbsScreen({super.key});

  @override
  ConsumerState<SavedHerbsScreen> createState() => _SavedHerbsScreenState();
}

class _SavedHerbsScreenState extends ConsumerState<SavedHerbsScreen> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedAsync = ref.watch(savedHerbsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: AppStrings.savedHerbsTitle,
            subtitle: AppStrings.savedHerbsSubtitle,
            showBack: true,
            height: 90,
            solidColor: true,
            // language: 'en', // TODO: hook up localization when ready
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    controller: _searchController,
                    hintText: AppStrings.searchSaved,
                    onChanged: (value) {
                      setState(() => _query = value.trim().toLowerCase());
                    },
                  ),
                  const SizedBox(height: 16),
                  savedAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, _) => _buildError(err.toString()),
                    data: (herbs) {
                      final filtered = _query.isEmpty
                          ? herbs
                          : herbs
                              .where((h) =>
                                  h.name.toLowerCase().contains(_query) ||
                                  (h.scientificName.toLowerCase().contains(_query)))
                              .toList();

                      if (filtered.isEmpty) return _buildEmptyState();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSummary(filtered.length),
                              const SizedBox(height: 16),
                              ...filtered.map(
                            (herb) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _SavedHerbTile(
                                herb: herb,
                                onDelete: () => _removeHerb(herb.id),
                              ),
                            ),
                          ),
                            ],
                          );
                        },
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
              const Icon(Icons.bookmark, size: 18, color: AppColors.secondaryGreen),
              const SizedBox(width: 6),
              Text(
                '${AppStrings.savedHerbsCountLabel}: $count',
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
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              AppStrings.savedHerbsEmpty,
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
            const Text(
              'Failed to load saved herbs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Register or login to the app to see your saved herbs",
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

  Future<void> _removeHerb(String herbId) async {
    final repo = ref.read(savedHerbsRepositoryProvider);
    try {
      await repo.deleteSavedHerb(herbId);
      if (!mounted) return;
      ref.invalidate(savedHerbsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Herb removed from saved list'),
          backgroundColor: AppColors.secondaryGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not remove herb. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

class _SavedHerbTile extends StatelessWidget {
  final HerbModel herb;
  final VoidCallback onDelete;

  const _SavedHerbTile({
    required this.herb,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InfoCard(
          title: herb.name,
          description: herb.description,
          tags: herb.skinConditions,
          extra: herb.category,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: 'Remove',
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}
