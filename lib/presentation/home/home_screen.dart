import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/presentation/recommendations/recommendations_screen.dart'
    show RecommendationsScreen;
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/widgets/shared/header_widget.dart';
import '../../core/widgets/cards/step_card.dart';
import '../../core/widgets/cards/feature_pill.dart';
import '../../core/widgets/cards/info_card.dart';
import '../../core/widgets/navigation/app_bottom_nav_bar.dart';
import 'home_view_model.dart';
import 'widgets/trusted_healers_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeViewModelProvider.notifier).loadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      // bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: AppStrings.homeTitle,
            subtitle: AppStrings.homeSubtitle,
            height: 200,
            actions: const [_HomeBadgesRow()],
            language: 'en', // TODO: hook up localization when ready
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                    const SizedBox(height: 10),

                  const Center(child: _GetStartedButton()),
                  const SizedBox(height: 16),
                  if (state.isLoading) ...[
                    const LinearProgressIndicator(),
                    // const SizedBox(height: 16),
                  ],
                  _buildHowToUseSection(),
                  const SizedBox(height: 32),
                  _buildWhyChooseSection(),
                  const SizedBox(height: 20),
                  _buildFeaturesRow(),
                  const SizedBox(height: 28),
                  _buildComprehensiveDbCard(),
                  const SizedBox(height: 16),
                  _buildEvidenceBasedCard(),
                  const SizedBox(height: 16),
                  const TrustedHealersCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToUseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.howToUse,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          AppStrings.howToUseSubtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              StepCard(
                number: '1',
                title: AppStrings.step1Title,
                description: AppStrings.step1Desc,
              ),
              StepCard(
                number: '2',
                title: AppStrings.step2Title,
                description: AppStrings.step2Desc,
              ),
              StepCard(
                number: '3',
                title: AppStrings.step3Title,
                description: AppStrings.step3Desc,
              ),
              StepCard(
                number: '4',
                title: AppStrings.step4Title,
                description: AppStrings.step4Desc,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhyChooseSection() {
    return const Center(
      child: Text(
        AppStrings.whyChoose,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFeaturesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        FeaturePill(icon: Icons.eco, label: AppStrings.herbsCount),
        FeaturePill(icon: Icons.verified, label: AppStrings.whoVerified),
        FeaturePill(icon: Icons.science, label: AppStrings.runBasedSystem),
      ],
    );
  }

  Widget _buildComprehensiveDbCard() {
    return const InfoCard(
      title: AppStrings.comprehensiveDb,
      description: AppStrings.comprehensiveDbDesc,
      tags: [
        AppStrings.communityDriven,
        AppStrings.multilingualAccess,
        AppStrings.fastReliable,
      ],
      extra: AppStrings.alignedStrategy,
    );
  }

  Widget _buildEvidenceBasedCard() {
    return const InfoCard(
      title: AppStrings.evidenceBased,
      description: AppStrings.evidenceBasedDesc,
      tags: [
        AppStrings.threeLanguages,
        AppStrings.instantResults,
      ],
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RecommendationsScreen()),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.secondaryGreen,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        side: const BorderSide(color: AppColors.secondaryGreen, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            AppStrings.getStarted,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.rocket_launch_outlined),
        ],
      ),
    );
  }
}

class _HomeBadgesRow extends StatelessWidget {
  const _HomeBadgesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _HomeBadge(icon: Icons.person, label: AppStrings.personalized),
         SizedBox(width: 20),
        _HomeBadge(icon: Icons.auto_awesome, label: AppStrings.traditionalWisdom),
                SizedBox(width: 20),
        _HomeBadge(icon: Icons.health_and_safety, label: AppStrings.safeAndNatural),
      ],
    );
  }
}

class _HomeBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HomeBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
