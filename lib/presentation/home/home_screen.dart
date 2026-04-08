import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/presentation/recommendations/recommendations_screen.dart'
    show RecommendationsScreen;
import '../../core/constants/colors.dart';
import '../../core/constants/languages/home_strings.dart';
import '../../core/state/language_provider.dart';
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
    Future.microtask(
        () => ref.read(homeViewModelProvider.notifier).loadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final language = ref.watch(languageProvider);
    final strings = HomeStrings.fromLanguage(language);
    final langNotifier = ref.read(languageProvider.notifier);

    return Scaffold(
      // bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: strings.homeTitle,
            subtitle: strings.homeSubtitle,
            height: 240,
            actions: [_HomeBadgesRow(strings: strings)],
            language: language,
            languageOptions: const ['eng', 'amh', 'or'],
            onLanguageSelected: langNotifier.setLanguage,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(child: _GetStartedButton(strings: strings)),
                  const SizedBox(height: 16),
                  if (state.isLoading) ...[
                    const LinearProgressIndicator(),
                    // const SizedBox(height: 16),
                  ],
                  _buildHowToUseSection(strings),
                  const SizedBox(height: 32),
                  _buildWhyChooseSection(strings),
                  const SizedBox(height: 20),
                  _buildFeaturesRow(strings),
                  const SizedBox(height: 28),
                  _buildComprehensiveDbCard(strings),
                  const SizedBox(height: 16),
                  _buildEvidenceBasedCard(strings),
                  const SizedBox(height: 16),
                  TrustedHealersCard(strings: strings),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToUseSection(HomeStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.howToUse,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          strings.howToUseSubtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              StepCard(
                number: '1',
                title: strings.step1Title,
                description: strings.step1Desc,
              ),
              StepCard(
                number: '2',
                title: strings.step2Title,
                description: strings.step2Desc,
              ),
              StepCard(
                number: '3',
                title: strings.step3Title,
                description: strings.step3Desc,
              ),
              StepCard(
                number: '4',
                title: strings.step4Title,
                description: strings.step4Desc,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhyChooseSection(HomeStrings strings) {
    return Center(
      child: Text(
        strings.whyChoose,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFeaturesRow(HomeStrings strings) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          FeaturePill(icon: Icons.eco, label: strings.herbsCount),
          FeaturePill(icon: Icons.verified, label: strings.whoVerified),
          FeaturePill(icon: Icons.science, label: strings.runBasedSystem),
        ],
      ),
    );
  }

  Widget _buildComprehensiveDbCard(HomeStrings strings) {
    return InfoCard(
      title: strings.comprehensiveDb,
      description: strings.comprehensiveDbDesc,
      tags: [
        strings.communityDriven,
        strings.multilingualAccess,
        strings.fastReliable,
      ],
      extra: strings.alignedStrategy,
    );
  }

  Widget _buildEvidenceBasedCard(HomeStrings strings) {
    return InfoCard(
      title: strings.evidenceBased,
      description: strings.evidenceBasedDesc,
      tags: [
        strings.threeLanguages,
        strings.instantResults,
      ],
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final HomeStrings strings;
  const _GetStartedButton({required this.strings});

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
        children: [
          Text(
            strings.getStarted,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.rocket_launch_outlined),
        ],
      ),
    );
  }
}

class _HomeBadgesRow extends StatelessWidget {
  final HomeStrings strings;
  const _HomeBadgesRow({required this.strings});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        _HomeBadge(icon: Icons.person, label: strings.personalized),
        _HomeBadge(icon: Icons.auto_awesome, label: strings.traditionalWisdom),
        _HomeBadge(
            icon: Icons.health_and_safety, label: strings.safeAndNatural),
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
      mainAxisSize: MainAxisSize.min,
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
        SizedBox(
          width: 100,
          child: Text(
            label,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
