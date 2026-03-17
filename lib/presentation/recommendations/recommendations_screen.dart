import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/widgets/inputs/search_bar.dart';
import 'recommendations_view_model.dart';
import 'widgets/concern_grid.dart';
import 'widgets/tips_card.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    Future.microtask(
      () => ref.read(recommendationsViewModelProvider.notifier).loadSkinConcerns(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationsViewModelProvider);
    final notifier = ref.read(recommendationsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.secondaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(),
            ),
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

  Widget _buildHeader() {
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
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 12),
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Expanded(
                  child: Text(
                    AppStrings.recommendationsTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.recommendationsSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FeatureBadge(icon: Icons.person, label: AppStrings.personalized),
              FeatureBadge(icon: Icons.auto_awesome, label: AppStrings.traditionalWisdom),
              FeatureBadge(icon: Icons.health_and_safety, label: AppStrings.safeAndNatural),
            ],
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
                    // TODO: hook up search filtering when available
                  },
                ),
              ),
            ),
          ],
        ),
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
