import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import 'recommendations_view_model.dart';
import 'widgets/step_indicator.dart';
import 'widgets/concern_grid.dart';
import 'widgets/tips_card.dart';
import 'widgets/privacy_notice.dart';
import 'widgets/trust_section.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(recommendationsViewModelProvider.notifier).loadSkinConcerns(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationsViewModelProvider);
    final notifier = ref.read(recommendationsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepIndicator(currentStep: state.currentStep),
                    const SizedBox(height: 24),
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
                    const PrivacyNotice(),
                    const SizedBox(height: 20),
                    const TrustSection(),
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
          const Text(
            AppStrings.recommendationsTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
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
          AppStrings.continueToProfile,
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
