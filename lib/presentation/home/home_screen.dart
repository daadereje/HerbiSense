import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/presentation/auth/login/login_screen.dart';
import 'package:herbisense/presentation/recommendations/recommendations_screen.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/widgets/shared/header_widget.dart';
import '../../core/widgets/cards/step_card.dart';
import '../../core/widgets/cards/feature_pill.dart';
import '../../core/widgets/cards/info_card.dart';
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
      body: CustomScrollView(
        slivers: [
          HeaderWidget(
            // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            title: AppStrings.homeTitle,
            subtitle: AppStrings.homeSubtitle,
            // Placeholder for future actions:
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecommendationsScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(AppStrings.getStarted),
                    SizedBox(width: 8),
                    Icon(Icons.rocket_launch_outlined),
                  ],
                ),
              ),
              // const SizedBox(width: 12),
              // OutlinedButton(
              //   onPressed: () {},
              //   child: const Text(AppStrings.skinConditions),
              // ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
