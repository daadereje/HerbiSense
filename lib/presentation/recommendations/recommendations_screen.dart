import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/languages/recommendations_strings.dart';
import '../../core/state/language_provider.dart';
import '../../core/widgets/navigation/app_bottom_nav_bar.dart';
import '../../core/widgets/inputs/search_bar.dart';
import '../../core/widgets/shared/header_widget.dart';
import 'recommendations_view_model.dart';
import 'widgets/concern_grid.dart';

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
  }

  Widget _buildSearchResults(String language) {
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
            condition.titleFor(language),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            condition.descriptionFor(language),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.info_outline,
                size: 20, color: AppColors.primaryGreen),
            onPressed: () {
              context.push('/condition-details', extra: condition);
            },
          ),
          onTap: () {
            context.push('/condition-details', extra: condition);
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemCount: state.searchResults.length,
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
    final RecommendationsState state =
        ref.watch(recommendationsViewModelProvider);
    final RecommendationsViewModel notifier =
        ref.read(recommendationsViewModelProvider.notifier);
    final language = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);
    final strings = RecommendationsStrings.fromLanguage(language);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: strings.recommendationsTitle,
            subtitle: strings.recommendationsSubtitle,
            height: 160,
            solidColor: true,
            language: language,
            languageOptions: const ['eng', 'amh', 'or'],
            onLanguageSelected: languageNotifier.setLanguage,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // StepIndicator(currentStep: state.currentStep),
                  // const SizedBox(height: 24),
                  _buildMainQuestion(strings, language),
                  const SizedBox(height: 20),
                  _buildSubtitle(strings),
                  const SizedBox(height: 16),
                  ConcernGrid(
                    concerns: state.skinConcerns,
                    language: language,
                    onConcernTap: notifier.showConditionDetail,
                  ),
                  // const SizedBox(height: 24),
                  // TipsCard(strings: strings),
                  // const SizedBox(height: 20),
                  // _buildContinueButton(notifier, state, strings),
                  // if (!state.hasSelection) _buildValidationMessage(strings),
                  // const SizedBox(height: 16),
                  // // const PrivacyNotice(),
                  // // const SizedBox(height: 20),
                  // // const TrustSection(),
                  const SizedBox(height: 20),
                  _buildFooter(strings),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainQuestion(RecommendationsStrings strings, String language) {
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
                  hintText: strings.searchHerbs,
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
        _buildSearchResults(language),
        const SizedBox(height: 16),
        Text(
          strings.whatAreYourConcerns,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          strings.selectAllThatApply,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(RecommendationsStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.selectYourConcerns,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          strings.chooseConditions,
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
    RecommendationsStrings strings,
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
        child: Text(
          strings.getSuggestions,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildValidationMessage(RecommendationsStrings strings) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        strings.selectAtLeastOne,
        style: TextStyle(
          fontSize: 12,
          color: Colors.red[400],
        ),
      ),
    );
  }

  Widget _buildFooter(RecommendationsStrings strings) {
    return Center(
      child: Text(
        strings.footer,
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
