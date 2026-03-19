import 'package:flutter/material.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/strings.dart';
import 'package:herbisense/core/widgets/cards/info_card.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/widgets/shared/header_widget.dart';
import 'package:herbisense/core/widgets/inputs/search_bar.dart';

class SavedHerbsScreen extends StatefulWidget {
  const SavedHerbsScreen({super.key});

  @override
  State<SavedHerbsScreen> createState() => _SavedHerbsScreenState();
}

class _SavedHerbsScreenState extends State<SavedHerbsScreen> {
  late final TextEditingController _searchController;

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
    final savedHerbs = _mockSavedHerbs; // TODO: replace with real data source

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
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
                      // TODO: hook up search filtering when data source is connected
                    },
                  ),
                  const SizedBox(height: 16),
                  if (savedHerbs.isEmpty)
                    _buildEmptyState()
                  else ...[
                    _buildSummary(savedHerbs.length),
                    const SizedBox(height: 16),
                    ...savedHerbs.map(
                      (herb) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: InfoCard(
                          title: herb.title,
                          description: herb.description,
                          tags: herb.tags,
                          extra: herb.extra,
                        ),
                      ),
                    ),
                  ],
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
}

class _SavedHerb {
  final String title;
  final String description;
  final List<String> tags;
  final String? extra;

  const _SavedHerb({
    required this.title,
    required this.description,
    required this.tags,
    this.extra,
  });
}

/// Temporary mock data until the saved-herbs feature is wired to real storage.
const List<_SavedHerb> _mockSavedHerbs = [
  _SavedHerb(
    title: 'Aloe Vera (Eret)',
    description: 'Soothing succulent used to calm irritated skin and support moisture balance.',
    tags: ['Cooling', 'Hydration', 'Anti-inflammatory'],
    extra: 'Great for sun-exposed or sensitive skin',
  ),
  _SavedHerb(
    title: 'Neem (Nim Tree)',
    description: 'Traditional antimicrobial leaf known for supporting clearer skin.',
    tags: ['Purifying', 'Antimicrobial', 'Oil Control'],
    extra: 'Often combined with turmeric for breakouts',
  ),
  _SavedHerb(
    title: 'Turmeric (Erd)',
    description: 'Root rich in curcumin; used for brightening and calming redness.',
    tags: ['Brightening', 'Anti-inflammatory', 'Antioxidant'],
    extra: 'Patch test before use to avoid staining',
  ),
];
