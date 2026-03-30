import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/data/models/skin_concern_model.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/widgets/navigation/app_bottom_nav_bar.dart';
import '../../core/widgets/inputs/search_bar.dart';
import '../../core/widgets/shared/header_widget.dart';
import 'recommendations_view_model.dart';
import 'widgets/concern_grid.dart';
import 'widgets/tips_card.dart';
import '../../data/models/herb_model.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() =>
      _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  late final TextEditingController _searchController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    Future.microtask(
      () => ref
          .read(recommendationsViewModelProvider.notifier)
          .loadSkinConcerns(),
    );
  }

  Widget _buildSearchResults() {
    final state = ref.watch(recommendationsViewModelProvider);
    if (_searchController.text.isEmpty) return const SizedBox.shrink();

    if (state.isSearchLoading) {
      return const LinearProgressIndicator(minHeight: 2);
    }

    if (state.searchError != null) {
      return Text(
        state.searchError!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      );
    }

    if (state.searchResults.isEmpty) {
      return const Text(
        'No conditions found. Try another keyword.',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        final condition = state.searchResults[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.healing, color: AppColors.primaryGreen),
          title: Text(
            condition.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            condition.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          trailing: const Icon(Icons.add, size: 18, color: AppColors.secondaryGreen),
          onTap: () {
            ref
                .read(recommendationsViewModelProvider.notifier)
                .selectConditionFromSearch(condition);
            _searchController.clear();
            FocusScope.of(context).unfocus();
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemCount: state.searchResults.length,
    );
  }

  void _showHerbDetails(BuildContext context, HerbModel herb) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          herb.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Text(
                      //   '#${herb.id}',
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                 
Text("Scientific Name",
style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 0.2,
          ),),
                      Text(
                        herb.scientificName,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.secondaryGreen,
                        ),
                      ),
                      if (herb.conditionName != null) ...[
                        const SizedBox(height: 12),
                
Text("Condition Used for",
style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 0.2,
          ),),
                        Text(
                          herb.conditionName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  _detailRow('Description', herb.description),
                  const SizedBox(height: 8),
                  _detailRow('Preparation', herb.preparation ?? 'Not provided'),
                  const SizedBox(height: 8),
                  _detailRow('Safety', herb.safetyWarning ?? 'No warnings'),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationsViewModelProvider);
    final notifier = ref.read(recommendationsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: 'Herbal\nRecommendations',
            subtitle: AppStrings.recommendationsSubtitle,
            height: 160,
            solidColor: true,
            language: 'en', // TODO: hook up localization when ready
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // StepIndicator(currentStep: state.currentStep),
                  // const SizedBox(height: 24),
                  _buildMainQuestion(),
                  const SizedBox(height: 20),
                  _buildSubtitle(),
                  const SizedBox(height: 16),
                  ConcernGrid(
                    concerns: state.skinConcerns,
                    onConcernTap: notifier.showSeverityDialog,
                  ),
                  const SizedBox(height: 24),
                  const TipsCard(),
                  const SizedBox(height: 20),
                  _buildContinueButton(notifier, state),
                  if (!state.hasSelection) _buildValidationMessage(),
                  const SizedBox(height: 16),
                  // const PrivacyNotice(),
                  // const SizedBox(height: 20),
                  // const TrustSection(),
                  // const SizedBox(height: 20),
                  _buildFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: CustomSearchBar(
                  controller: _searchController,
                  hintText: AppStrings.searchHerbs,
                  onChanged: (value) {
                    _searchDebounce?.cancel();
                    _searchDebounce =
                        Timer(const Duration(milliseconds: 350), () {
                      ref
                          .read(recommendationsViewModelProvider.notifier)
                          .searchConditions(value);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSearchResults(),
        const SizedBox(height: 16),
        const Text(
          AppStrings.whatAreYourConcerns,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.selectAllThatApply,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.selectYourConcerns,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.chooseConditions,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(
    RecommendationsViewModel notifier,
    RecommendationsState state,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.hasSelection ? notifier.continueToNextStep : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryGreen,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          AppStrings.getSuggestions,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildValidationMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        AppStrings.selectAtLeastOne,
        style: TextStyle(
          fontSize: 12,
          color: Colors.red[400],
        ),
      ),
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
}

class FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
