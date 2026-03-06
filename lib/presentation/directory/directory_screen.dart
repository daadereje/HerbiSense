import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/widgets/inputs/search_bar.dart';
import 'directory_view_model.dart';
import 'widgets/filter_sidebar.dart';
import 'widgets/herb_list.dart';
import 'widgets/stats_section.dart';

class DirectoryScreen extends ConsumerStatefulWidget {
  const DirectoryScreen({super.key});

  @override
  ConsumerState<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends ConsumerState<DirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(directoryViewModelProvider.notifier).loadHerbs());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(directoryViewModelProvider);
    final notifier = ref.read(directoryViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(notifier),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPublishedInfo(state),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: FilterSidebar(
                            selectedCondition: state.selectedCondition,
                            onConditionSelected: notifier.setSelectedCondition,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 7,
                          child: HerbList(
                            herbs: state.filteredHerbs,
                            totalCount: state.totalHerbs,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    StatsSection(
                      totalHerbs: state.totalHerbs,
                      publishedCount: state.publishedCount,
                      lastSync: state.lastSync,
                    ),
                    const SizedBox(height: 20),
                    _buildFooter(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic notifier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.secondaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.directoryTitle,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.directorySubtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          CustomSearchBar(
            controller: _searchController,
            hintText: AppStrings.searchHint,
            onChanged: notifier.setSearchQuery,
          ),
        ],
      ),
    );
  }

  Widget _buildPublishedInfo(DirectoryState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.publishedHerbs,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Showing ${state.filteredHerbs.length} of ${state.totalHerbs} herbs',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Last updated: ${state.lastSync}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        AppStrings.footer,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
